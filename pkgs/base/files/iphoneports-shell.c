#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main() {
    char shell[1024] = "/var/usr/bin/sh";
    if (access("/var/usr/shell", F_OK) == 0)
        readlink("/var/usr/shell", shell, 1024);
    char* shellname = strdup(strrchr(shell, '/'));
    shellname[0] = '-';
    setenv("SHELL", shell, 1);
    return execl(shell, shellname, NULL);
}
