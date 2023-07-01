#include "types.h"
#include "fcntl.h"
#include "user.h"

int main(int argc, char* argv[]){
    write(1, "testing find_fibonacci_number system call started\n", 50);
    
    if(argc != 2){
        write(1, "Invalid input. Please enter just a single integer.\n", 51);
        exit();
    }
    
    int n = atoi(argv[1]), prev_ebx;
    
    asm volatile(
        "movl %%ebx, %0;"
        "movl %1, %%ebx;"
        : "=r" (prev_ebx)
        : "r"(n)
        );

    printf(1, "calling find_fibonacci_number(%d)\n", n);

    int answer = find_fibonacci_number();

    asm volatile(
        "movl %0, %%ebx;"
        : : "r"(prev_ebx)
    );

    if(answer == -1){
        printf(1, "find_fibonacci_number failed\n");
        printf(1, "Please check if you entered an integer smaller than 1\n");
        exit();
    }

    printf(1, "find_fibonacci_number(%d) = %d\n", n, answer);
    exit();
}

