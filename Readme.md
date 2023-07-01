# All OS lab projects offered at University of Tehran - Spring 2023


## Contributors:
1. [Seyedeh Zeinab Pishbeen](https://github.com/PishbinZein)
2. [Mohammad Javad Besharati](https://github.com/JavadBesharati)

---

## Description:
During 5 labs, new features added to xv6 operating system.

---

### Lab 1:
* A text message added to boot messages.
* Cursor comes to beginning of line by pressing shift + '[' keys.
* Cursor goes to end of line by pressing shift + ']' keys.
* Pressing Ctrl + 'W' will remove the word before cursor.
* A user level program has been written called mmm.c. This program receives at most 7 numbers and shows their mean, median and mode. Result is saved to mmm_result.txt file.
* A new kernel module has been created. This module shows the names of group members in the output of the dmsg command. You can find its code in new_module file.

---

### Lab 2:
Some new system calls added to xv6:
* System call to find most called system call.
* System call to find current process childern count.
* System call to kill the first child of current process.

---

### Lab 3:
Some new schedulers and required system calls added to xv6:
* Aging mechanism has been implemented.
* Round Robin scheduler has been implemented.
* Lottery scheduler has been implemented.
* FCFS scheduler has been implemented.
* Modifying processes queue system call added.
* Initializing lottery ticket system call added.
* Printing processes info system call added.
* A user level program called foo.c has been written to test mentioned modifications.

---

### Lab 4:
This lab was about synchronization and readers-priority readers-writers problem was implemented. Some new system calls to simulate this problem added to xv6:
* sem_init(i, v)
* sem_aquire(i)
* sem_release(i)

---

### Lab 5:
This lab was about memory management in xv6. In this lab we modified xv6 address space such that it becomes like linux address space.
