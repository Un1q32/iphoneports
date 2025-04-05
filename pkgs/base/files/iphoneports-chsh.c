#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

int main(int argc, const char *argv[]) {
  if (__builtin_expect(geteuid() != 0, 0)) {
    puts("Error: not root, is iphoneports-chsh suid root?");
    return EXIT_FAILURE;
  }

  if (__builtin_expect(argc != 2, 0)) {
    puts("Change the default iPhonePorts shell\n\nUsage: iphoneports-chsh "
         "<SHELL>\n\nSHELL must be an executable in /var/usr/bin");
    return EXIT_FAILURE;
  }

  size_t shelllen = strlen(argv[1]);
  char *shell = malloc(shelllen + 14);
  if (__builtin_expect(!shell, 0)) {
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
  if (!S_ISREG(st.st_mode)) {
    fprintf(stderr, "Error: %s is not a regular file\n", shell);
    return EXIT_FAILURE;
  }
  if (!(st.st_mode & S_IXUSR)) {
    fprintf(stderr, "Error: %s is not executable\n", shell);
    return EXIT_FAILURE;
  }
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
