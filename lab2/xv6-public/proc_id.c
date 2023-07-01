#include "types.h"
#include "user.h"

int main(int argc, char* argv[]){
    int proc_id = getpid();
    printf(1, "Process ID is: %d\n", proc_id);
    exit();
}
