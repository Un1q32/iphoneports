#include <limits.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main() {
    char shell[PATH_MAX] = "/var/usr/bin/sh";
    if (access("/var/usr/shell", F_OK) == 0)
        readlink("/var/usr/shell", shell, PATH_MAX);
    const char *ptr = strrchr(shell, '/');
    char shellname[strlen(ptr) + 1];
    strcpy(shellname, ptr);
    shellname[0] = '-';
    setenv("SHELL", shell, 1);
    return execl(shell, shellname, NULL);
}
