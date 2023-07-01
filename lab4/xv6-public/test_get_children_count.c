#include "types.h"
#include "fcntl.h"
#include "user.h"
#include "syscall.h"

int main(int argc, char* argv[]){
    printf(1, "calling get_children_count\n");

    int c1 = fork();
    int c2 = fork();
    int c3 = fork();

    if(c1 > 0 && c2 > 0 && c3 > 0){ 
        printf(1, "Children count of parent is: %d\n", get_children_count());
    }
    // wait for all children to die :(
    while(wait() != -1) {}
    // give time to parent to reach wait clause
    sleep(1);
    exit();
}
