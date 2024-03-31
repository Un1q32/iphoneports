#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

bool checkshell(const char *shell, bool exitonfail) {
    struct stat st;
    if (stat(shell, &st) != 0) {
        printf("Error: %s not found!\n", shell);
        if (exitonfail)
            exit(EXIT_FAILURE);
        return false;
    }
    if (!S_ISREG(st.st_mode)) {
        printf("Error: %s is not a regular file!\n", shell);
        if (exitonfail)
            exit(EXIT_FAILURE);
        return false;
    }
    if ((st.st_mode & S_IXUSR) == 0) {
        printf("Error: %s is not executable!\n", shell);
        if (exitonfail)
            exit(EXIT_FAILURE);
        return false;
    }
    return true;
}

int main(int argc, char *argv[]) {
    char shell[PATH_MAX] = "/var/usr/bin/sh";
    (void)argc;
    (void)argv;
    if (access("/var/usr/shell", F_OK) == 0) {
        readlink("/var/usr/shell", shell, PATH_MAX);
        if (!checkshell(shell, false))
            strcpy(shell, "/var/usr/bin/sh");
    }
    checkshell(shell, true);
    const char *ptr = strrchr(shell, '/');
    char shellname[strlen(ptr) + 1];
    strcpy(shellname, ptr);
    shellname[0] = '-';
    setenv("SHELL", shell, 1);
    execl(shell, shellname, NULL);
    puts("Error: exec failed!");
    return EXIT_FAILURE;
}
