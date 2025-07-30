#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

int main(int argc, const char *argv[]) {
  if (geteuid() != 0) {
    puts("Error: not root, is iphoneports-chsh suid root?");
    return EXIT_FAILURE;
  }

  if (argc != 2) {
    puts("Change the default iPhonePorts shell\n\nUsage: iphoneports-chsh "
         "<SHELL>\n\nSHELL must be an executable in /var/usr/bin");
    return EXIT_FAILURE;
  }

  size_t shelllen = strlen(argv[1]);
  char *shell = malloc(shelllen + 14);
  if (!shell) {
    fprintf(stderr, "Error: not enough memory");
    return EXIT_FAILURE;
  }
  memcpy(shell, "/var/usr/bin/", 13);
  memcpy(shell + 13, argv[1], shelllen + 1);

  struct stat st;
  if (stat(shell, &st) != 0) {
    fprintf(stderr, "Error: cannot stat %s\n", shell);
    return EXIT_FAILURE;
  }
#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 20000) ||               \
    defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) ||                  \
    defined(__ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__) ||                  \
    defined(__ENVIRONMENT_TV_OS_VERSION_MIN_REQUIRED__)
  if (!S_ISREG(st.st_mode)) {
    fprintf(stderr, "Error: %s is not a regular file\n", shell);
    return EXIT_FAILURE;
  }
  if (!(st.st_mode & S_IXUSR)) {
    fprintf(stderr, "Error: %s is not executable\n", shell);
    return EXIT_FAILURE;
  }
#endif
  if (unlink("/var/usr/shell") != 0 && errno != ENOENT) {
    perror("Error: unlink");
    return EXIT_FAILURE;
  }
  if (symlink(shell, "/var/usr/shell") != 0) {
    perror("Error: symlink");
    return EXIT_FAILURE;
  }
  printf("iPhonePorts shell changed to %s\n", argv[1]);
  return EXIT_SUCCESS;
}
