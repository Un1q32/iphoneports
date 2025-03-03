#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

static bool checkshell(const char *shell, bool exitonfail) {
  struct stat st;
  if (__builtin_expect(stat(shell, &st) != 0, 0)) {
    printf("Error: %s not found!\n", shell);
    if (exitonfail)
      exit(EXIT_FAILURE);
    return false;
  }
  if (__builtin_expect(!S_ISREG(st.st_mode), 0)) {
    printf("Error: %s is not a regular file!\n", shell);
    if (exitonfail)
      exit(EXIT_FAILURE);
    return false;
  }
  if (__builtin_expect(!(st.st_mode & S_IXUSR), 0)) {
    printf("Error: %s is not executable!\n", shell);
    if (exitonfail)
      exit(EXIT_FAILURE);
    return false;
  }
  return true;
}

int main(void) {
  char shell[PATH_MAX] = "/var/usr/bin/sh";
  if (access("/var/usr/shell", F_OK) == 0) {
    if (__builtin_expect(readlink("/var/usr/shell", shell, PATH_MAX) == -1,
                         0) ||
        __builtin_expect(!checkshell(shell, false), 0))
      strcpy(shell, "/var/usr/bin/sh");
  }
  checkshell(shell, true);
  const char *ptr = strrchr(shell, '/');
  char shellname[strlen(ptr) + 1];
  strcpy(shellname, ptr);
  shellname[0] = '-';
  setenv("SHELL", shell, 1);
  execl(shell, shellname, NULL);
  perror("exec");
  return EXIT_FAILURE;
}
