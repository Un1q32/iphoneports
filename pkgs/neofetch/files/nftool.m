// program to help out neofetch, since some information is impossible to get with just shell

#include <stdio.h>
#include <mach/mach.h>
#include <UIKit/UIKit.h>

void usedmem() {
    vm_statistics64_data_t vm_stat;
    mach_msg_type_number_t count = sizeof(vm_stat) / sizeof(natural_t);
    host_statistics64(mach_host_self(), HOST_VM_INFO64, (host_info64_t)&vm_stat, &count);
    printf("%llu\n", (vm_stat.active_count + vm_stat.inactive_count) * 4ULL);
}

void resolution() {
    CGRect screenSizeRect = [[UIScreen mainScreen] bounds];
    int width = screenSizeRect.size.width;
    int height = screenSizeRect.size.height;
    printf("%dx%d\n", width, height);
}

int main(int argc, char *argv[]) {
    char usage[100];
    sprintf(usage, "Usage: %s [usedmem|resolution]\n", argv[0]);
    if (argc < 2) {
        fprintf(stderr, "%s", usage);
        return 1;
    }
    if (strcmp(argv[1], "usedmem") == 0) {
        usedmem();
    } else if (strcmp(argv[1], "resolution") == 0) {
        resolution();
    } else {
        fprintf(stderr, "%s", usage);
        return 1;
    }
    return 0;
}
