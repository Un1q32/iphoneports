#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

static bool checkshell(const char *shell, bool exitonfail) {
  struct stat st;
  if (stat(shell, &st) != 0) {
    printf("Error: %s not found!\n", shell);
    if (exitonfail)
      exit(EXIT_FAILURE);
    return false;
  }
#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 20000) ||               \
    defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) ||                  \
    defined(__ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__) ||                  \
    defined(__ENVIRONMENT_TV_OS_VERSION_MIN_REQUIRED__)
  if (!S_ISREG(st.st_mode)) {
    printf("Error: %s is not a regular file!\n", shell);
    if (exitonfail)
      exit(EXIT_FAILURE);
    return false;
  }
#endif
  if (!(st.st_mode & S_IXUSR)) {
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
    if (readlink("/var/usr/shell", shell, PATH_MAX) == -1 ||
        !checkshell(shell, false))
      strcpy(shell, "/var/usr/bin/sh");
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
