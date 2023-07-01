#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

// system call to find the nth fibonacci number:

int sys_find_fibonacci_number(void){
  int n = myproc()->tf->ebx;
  cprintf("Kernel: sys_find_fibonacci_number(%d) is called\n", n);
  cprintf("        now calling find_fibonacci_number(%d)\n", n);
  return find_fibonacci_number(n);
}

// system call to find the most used system call:

int sys_find_most_callee(void){
  cprintf("Kernel: sys_find_most_callee is called\n");
  cprintf("        now calling find_most_callee\n");
  return find_most_callee();
}

// system call to get children count of current process:

int sys_get_children_count(void){
  cprintf("Kernel: sys_get_children_count is called\n");
  cprintf("        now calling get_children_count\n");
  return get_children_count();
}

// system call to kill the first child of a process:

int sys_kill_first_child_process(void){
  cprintf("Kernel: sys_kill_first_child_process is called\n");
  cprintf("        now calling kill_first_child_process\n");
  return kill_first_child_process();
}
