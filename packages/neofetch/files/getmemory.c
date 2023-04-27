// output should be
// mem_total=<total memory in KB>
// mem_used=<used memory in KB>
// for use with neofetch
#include <stdio.h>
#include <sys/sysinfo.h>
int main() {
    struct sysinfo info;
    sysinfo(&info);
    const long totalmem = info.totalram / 1024;
    const long usedmem = (info.totalram - info.freeram - info.bufferram - info.sharedram) / 1024;
    printf("mem_total=%ld\nmem_used=%ld\n", totalmem, usedmem);
    return 0;
}
