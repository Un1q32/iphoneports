#include <spawn.h>
#include <string.h>

size_t strnlen(const char *str, size_t maxlen) {
  const char *end = memchr(str, '\0', maxlen);
  return end ? (size_t)(end - str) : maxlen;
}

void pthread_setname_np(const char *name) { (void)name; }

int posix_spawn_file_actions_addinherit_np(posix_spawn_file_actions_t *fa,
                                           int fd) {
  (void)fa;
  (void)fd;
  return 0;
}
