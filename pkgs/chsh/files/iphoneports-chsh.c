#include <stdio.h>
#include <unistd.h>
int main(int argc, char* argv[]) {
    if (geteuid() != 0) {
        puts("Error: not root, is iphoneports-chsh suid root?");
        return 1;
    }

    if (argc != 2) {
        puts("iPhonePorts chsh - change the default iPhonePorts shell\n\nUsage: iphoneports-chsh <SHELL>\n\nSHELL must be an executable in /var/usr/bin");
        return 1;
    }

    char shell[256];
    sprintf(shell, "/var/usr/bin/%s", argv[1]);

    if (access(shell, X_OK) == -1) {
        fprintf(stderr, "Error: %s is not a valid shell\n", argv[1]);
        return 1;
    }

    unlink("/var/usr/shell");
    symlink(shell, "/var/usr/shell");
    return 0;
}
