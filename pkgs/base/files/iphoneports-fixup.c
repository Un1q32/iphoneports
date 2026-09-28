#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(void) {
  if (access("/var/usr", F_OK) == 0)
    return EXIT_SUCCESS;
  if (access("/var/jb/iphoneports", F_OK) == 0) {
    if (symlink("/var/jb/iphoneports", "/var/usr") == 0)
      return EXIT_SUCCESS;
    perror("symlink");
  }
  return EXIT_FAILURE;
}
