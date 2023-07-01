#include <linux/module.h>
#include <linux/kernel.h>

MODULE_LICENSE("GPL");

int init_module(void){
    printk(KERN_INFO "Group #13:\n1. Arshia\n2. Zeinab\n3. Javad\n");
    return 0;
}

void cleanup_module(void) {}
