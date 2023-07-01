#include "types.h"
#include "fcntl.h"
#include "user.h"
#include "syscall.h"

int main(int argc, char* argv[]){
    printf(1, "calling find_most_callee\n");
    int most_used_sys_call = find_most_callee();
    printf(1, "Most used system call number is: %d\n", most_used_sys_call);
    exit();
}
