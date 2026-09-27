#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

static bool checkshell(const char *shell, bool fatal) {
  struct stat st;
  if (stat(shell, &st) != 0) {
    if (fatal) {
      printf("Error: %s not found!\n", shell);
      exit(EXIT_FAILURE);
    }
    return false;
  }
  if (!S_ISREG(st.st_mode)) {
    if (fatal) {
      printf("Error: %s is not a regular file!\n", shell);
      exit(EXIT_FAILURE);
    }
    return false;
  }
  if (!(st.st_mode & S_IXUSR)) {
    if (fatal) {
      printf("Error: %s is not executable!\n", shell);
      exit(EXIT_FAILURE);
    }
    return false;
  }
  return true;
}

int main(void) {
  if (access("/var/usr", F_OK) == -1) {
    if (access("/var/jb/iphoneports", F_OK) == 0) {
      pid_t pid = fork();
      if (pid == -1) {
        perror("fork");
        fprintf(stderr, "/var/usr doesn't exist, and /var/jb/iphoneports does, "
                        "but we couldn't regenerate the symlink.\n"
                        "Try manually running "
                        "/var/jb/iphoneports/libexec/iphoneports-fixup before "
                        "re-running iphoneports-shell.\n");
        return EXIT_FAILURE;
      } else if (pid == 0) {
        execl("/var/jb/iphoneports/libexec/iphoneports-fixup", NULL);
        perror("exec");
        fprintf(stderr, "/var/usr doesn't exist, and /var/jb/iphoneports does, "
                        "but we couldn't regenerate the symlink.\n"
                        "Try reinstalling iphoneports-base before re-running "
                        "iphoneports-shell.\n");
        return EXIT_FAILURE;
      }
      int status;
      wait(&status);
      if (WEXITSTATUS(status) != EXIT_SUCCESS) {
        fprintf(stderr, "/var/usr doesn't exist, and /var/jb/iphoneports does, "
                        "but we couldn't regenerate the symlink.\n"
                        "Try reinstalling iphoneports-base before re-running "
                        "iphoneports-shell.\n");
        return EXIT_FAILURE;
      }
    } else {
      fprintf(
          stderr,
          "Couldn't find iPhonePorts, your environment may be corrupted.\n");
      return EXIT_FAILURE;
    }
  }
  char shell[PATH_MAX] = "/var/usr/bin/bash";
  if (access("/var/usr/shell", F_OK) == 0) {
    ssize_t ret = readlink("/var/usr/shell", shell, PATH_MAX);
    if (ret == -1)
      strcpy(shell, "/var/usr/bin/bash");
    else {
      shell[ret] = '\0';
      if (!checkshell(shell, false))
        strcpy(shell, "/var/usr/bin/bash");
    }
  }
  checkshell(shell, true);
  const char *ptr = strrchr(shell, '/');
  char shellname[strlen(ptr) + 1];
  strcpy(shellname, ptr);
  shellname[0] = '-';
  setenv("SHELL", shell, 1);
  setenv("LANG", "C", 0);
  execl(shell, shellname, NULL);
  perror("exec");
  return EXIT_FAILURE;
}
