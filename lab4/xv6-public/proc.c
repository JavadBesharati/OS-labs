#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

#define STARVING_THRESHOLD      8000
#define DEFAULT_MAX_TICKETS     30
#define MAX_SEMAPHORE           5

struct {
  struct spinlock lock;
  struct proc* proc[NPROC];
  int last;
  int v;
  int m;
} semaphores[MAX_SEMAPHORE];

struct
{
  struct spinlock lock;
} condvar;

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
int readers_cnt = 0;
int writers_cnt = 0;

extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);


int
random_number_generator(int min, int max)
{
    if (min >= max)
        return max > 0 ? max : -1 * max;
    acquire(&tickslock);
    int random_number, diff = max - min + 1, time = ticks;
    release(&tickslock);
    random_number = (1 + (1 + ((time + 2) % diff ) * (time + 1) * 132) % diff) * (1 + time % max) * (1 + 2 * max % diff);
    random_number = random_number % (max - min + 1) + min;
    return random_number;
}

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  // p->creation_time = ticks;

  // acquire(&tickslock);
  // p->creation_time = ticks;
  // release(&tickslock);

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  p->entered_queue = ticks;
  p->queue = 2;
  p->tickets = random_number_generator(1, DEFAULT_MAX_TICKETS);

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.

// to implement aging:
void
fix_queues(void)
{
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == RUNNABLE){
      if(ticks - p->entered_queue >= STARVING_THRESHOLD){
        p->queue = 1;
        p->entered_queue = ticks;
      }
    }
  }
}


struct proc*
round_robin(void) // for queue 1 with the highest priority
{ 
    struct proc *p;
    struct proc *min_p = 0;
    int time = ticks;
    int starvation_time = 0;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state != RUNNABLE || p->queue != 1)
            continue;
            
        if (p->state != RUNNABLE || p->queue != 1)
            continue;

        int starved_for = time - p->entered_queue;
        if (starved_for > starvation_time) {
            starvation_time = starved_for;
            min_p = p;
        }
    }
    return min_p;
}

struct proc*
lottery(void)
{
  struct proc* p;
  int total_tickets = 0;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state != RUNNABLE || p->queue != 2){
      continue;
    }
    total_tickets += p->tickets;
  }

  int winning_ticket = random_number_generator(1, total_tickets);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state != RUNNABLE || p->queue != 2){
      continue;
    }
    winning_ticket -= p->tickets;
    if(winning_ticket <= 0){
      return p;
    }
  }
  return 0;
}

struct proc*
fcfs(void)
{
  struct proc* p;
  struct proc* first_proc = 0;

  int mn = 2e9;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state != RUNNABLE || p->queue != 3){
      continue;
    }
    if(p->entered_queue < mn){
      mn = p->entered_queue;
      first_proc = p;
    }
  }

  return first_proc;
}

void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;

  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);

    fix_queues();
    p = round_robin();

    if(p == 0){
      p = lottery();
    }

    if(p == 0){
      p = fcfs();
    }

    if(p == 0){
      release(&ptable.lock);
      continue;
    }

    p->entered_queue = ticks;

    // Switch to chosen process.  It is the process's job
    // to release ptable.lock and then reacquire it
    // before jumping back to us.
    c->proc = p;
    switchuvm(p);
    p->state = RUNNING;

    swtch(&(c->scheduler), p->context);
    switchkvm();

    // Process is done running for now.
    // It should have changed its p->state before coming back.
    c->proc = 0;

    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

// find the nth fibonacci number:
int find_fibonacci_number(int n) {
    if(n > 1 && n < 4) {
        return 1;
    }
    else if(n == 1) {
        return 0;
    }
    else if (n < 1) {
        return -1;
    }
    else{
        return find_fibonacci_number(n - 1) + find_fibonacci_number(n - 2);
    }
}

// an array to keep how many times each system call called
int syscalls_count[NUM_OF_SYSCALLS] = {0};

void update_syscalls_count(int num){
    syscalls_count[num - 1] = syscalls_count[num - 1] + 1;
}

int find_most_callee(void){
    int most_used_sys_call = 0;
    int max_called = -1;
    
    for(int i = 0; i < NUM_OF_SYSCALLS; i++){
      if(syscalls_count[i] > max_called){
        most_used_sys_call = i + 1;
        max_called = syscalls_count[i];
      }
    }

    return most_used_sys_call;
}

// a function to return children count of current process:
int get_children_count(void){
    int pid = myproc()->pid;
    struct proc *p;
    int children_count = 0;
    
    acquire(&ptable.lock);

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent->pid == pid){
        children_count++;
      }
    }

    release(&ptable.lock);

    return children_count;
}

// a function to kill the first child of current process:

int kill_first_child_process(void){
  int pid = myproc()->pid;
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent->pid == pid){
      kill(p->pid);
      // If child killed successfully, return 1
      return 1;
    }
  }
  // If parent has no child, return -1
  return -1;
}

void
set_proc_queue(int pid, int queue)
{
  struct proc* p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->queue = queue;
    }
  }
  release(&ptable.lock);
}

void 
set_lottery_params(int pid, int ticket_chance){
  struct proc* p;
  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->tickets = ticket_chance;
    }
  }

  release(&ptable.lock);
}

int
digit_counter(int number)
{
  int count = 0;
  
  if(number == 0){
    return 1;
  }

  while(number > 0){
    number /= 10;
    count++;
  }

  return count;
}

void
print_all_procs()
{
  struct proc* p;
  cprintf("name           pid         state        queue    arrive time        ticket      cycle\n");
  cprintf(".............................................................................................\n");
  acquire(&ptable.lock);
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED){
      continue;
    }
    cprintf(p->name);
  
    for(int i = 0; i < 17 - strlen(p->name); i++){ // 15 instead 11
      cprintf(" ");
    }

    cprintf("%d", p->pid);

    for(int i = 0; i < 10 - digit_counter(p->pid); i++){
      cprintf(" ");
    }

    char* state = "";
    if(p->state == 0){
      state = "UNUSED";
    }
    else if(p->state == 1){
      state = "EMBRYO";
    }
    else if(p->state == 2){
      state = "SLEEPING";
    }
    else if(p->state == 3){
      state = "RUNNABLE";
    }
    else if(p->state == 4){
      state = "RUNNING";
    }
    else if(p->state == 5){
      state = "ZOMBIE";
    }
    cprintf(state);

    for(int i = 0; i < 12 - strlen(state); i++){
      cprintf(" ");
    }

    char* queue = "";
    if(p->queue == 1){
      queue = "ROUND ROBIN";
    }
    else if(p->queue == 2){
      queue = "LOTTERY";
    }
    else if(p->queue == 3){
      queue = "FCFS";
    }
    cprintf(queue);

    for(int i = 0; i < 12 - strlen(queue); i++){
      cprintf(" ");
    }

    cprintf("%d", p->entered_queue);
  
    for(int i = 0; i < 20 - digit_counter(p->entered_queue); i++){
      cprintf(" ");
    }

    cprintf("%d", p->tickets);

    for(int i = 0; i < 11 - digit_counter(p->tickets); i++){
      cprintf(" ");
    }

    int cycle = ticks - p->entered_queue;
    cprintf("%d", cycle);

    cprintf("\n");
  }
  
  release(&ptable.lock);
}

void sem_init(int i, int v_, int m_)
{
  acquire(&semaphores[i].lock);
  semaphores[i].v = v_;
  semaphores[i].m = m_;
  semaphores[i].last = 0;
  release(&semaphores[i].lock);
}

void sem_acquire(int i)
{
  acquire(&semaphores[i].lock);
  if (semaphores[i].m < semaphores[i].v)
  {
    semaphores[i].m++;
  }
  else
  {
    semaphores[i].proc[semaphores[i].last] = myproc();
    semaphores[i].last++;
    sleep(myproc(), &semaphores[i].lock);
  }
  release(&semaphores[i].lock);
}

void sem_release(int i)
{
  acquire(&semaphores[i].lock);
  if (semaphores[i].m < semaphores[i].v && semaphores[i].m > 0)
  {
    semaphores[i].m--;
  }
  else if (semaphores[i].m == semaphores[i].v)
  {
    if (semaphores[i].last == 0)
    {
      semaphores[i].m--;
    }
    else
    {
      wakeup(semaphores[i].proc[0]);
      for (int j = 1; j < NPROC; j++)
        semaphores[i].proc[j - 1] = semaphores[i].proc[j];
      semaphores[i].last--;
    }
  }
  release(&semaphores[i].lock);
}

void producer(int i)
{
  while (i < 10)
  {
    cprintf("produce an item %d in next produced\n", i);
    sem_acquire(1);
    sem_acquire(0);
    cprintf("add next produced to the buffer\n");
    sem_release(0);
    sem_release(2);
    i++;
  }
}

void consumer(int i)
{
  while (i < 10)
  {
    sem_acquire(2);
    sem_acquire(0);
    cprintf("remove an item from buffer to next consumed\n");
    sem_release(0);
    sem_release(1);
    cprintf("consume the item %d in next consumed\n", i);
    i++;
  }
}

void to_sleep(void *chan)
{
  struct proc *p = myproc();

  if (p == 0)
    panic("sleep");

  acquire(&ptable.lock);

  p->chan = chan;
  p->state = SLEEPING;

  sched();

  p->chan = 0;

  release(&ptable.lock);
}

void cv_wait(void *condvar)
{
  to_sleep(condvar);
}

void cv_signal(void *condvar)
{
  wakeup(condvar);
}

int test_variable = 0;

void reader(int i, void *condvar)
{
  readers_cnt++;
  cprintf("reader %d init\n", i);
  if (writers_cnt)
  {
    cv_wait(&condvar);
  }
  cprintf("reader %d reads one item from buffer\n", i);
  cprintf("number of active readers: %d\n", readers_cnt);
  readers_cnt--;
  cv_signal(&condvar);
}

void writer(int i, void *condvar)
{
  cprintf("readers: %d\n", readers_cnt);
  cprintf("writer %d init\n", i);
  if (readers_cnt || writers_cnt)
  {
    cv_wait(&condvar);
  }
  writers_cnt++;
  test_variable++;
  cprintf("test varibale is %d\n", test_variable);
  cprintf("writer %d writes next item in buffer\n", i);
  cprintf("number of active writers: %d\n", writers_cnt);
  writers_cnt--;
  cv_signal(&condvar);
}