#include "types.h"
#include "fcntl.h"
#include "user.h"
#include "syscall.h"

int main(int argc, char* argv[]){
    printf(1, "calling kill_first_child_process\n");

    int c1 = fork();

    if(c1 > 0){
        printf(1, "Children count before any child is killed: %d\n", get_children_count());
        int kill_result = kill_first_child_process();
        while(wait() != -1) {}
        sleep(1);
        if(kill_result == 1){
            printf(1, "First child was killed successfully.\n");
            printf(1, "Children count after first child was killed: %d\n", get_children_count());
            exit();
        }
        else{
            printf(1, "Parent has no child.\n");
            exit();
        }
    }
    else{
        printf(1, "Error in fork\n");
        exit();
    }
}
