#include <fcntl.h>
#include <limits.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

#include "compat.h"

void explicit_bzero(void *d, size_t n) {
  d = memset(d, 0, n);
  __asm__ __volatile__("" : : "r"(d) : "memory");
}

int mkdirat(int fd, const char *path, mode_t mode) {
  if (fd == AT_FDCWD || path[0] == '/')
    return mkdir(path, mode);

  char fdpath[PATH_MAX];
  if (fcntl(fd, F_GETPATH, fdpath) == -1)
    return -1;

  char new_path[strlen(fdpath) + strlen(path) + 1];
  strcpy(new_path, fdpath);
  strcat(new_path, "/");
  strcat(new_path, path);
  return mkdir(new_path, mode);
}

int openat(int fd, const char *path, int flags, ...) {
  mode_t mode = 0;
  if (flags & O_CREAT) {
    va_list va_args;
    va_start(va_args, flags);
    mode = va_arg(va_args, int);
    va_end(va_args);
  }

  if (fd == AT_FDCWD || path[0] == '/')
    return open(path, flags, mode);

  char fdpath[PATH_MAX];
  if (fcntl(fd, F_GETPATH, fdpath) == -1)
    return -1;

  char new_path[strlen(fdpath) + strlen(path) + 1];
  strcpy(new_path, fdpath);
  strcat(new_path, "/");
  strcat(new_path, path);
  return open(new_path, flags, mode);
}

void *memmem(const void *haystack, size_t haystacklen, const void *needle,
             size_t needlelen) {
  if (needlelen > haystacklen)
    return NULL;

  const char *h = haystack;
  const char *n = needle;
  for (size_t i = 0; i <= haystacklen - needlelen; i++)
    if (memcmp(h + i, n, needlelen) == 0)
      return (void *)(h + i);
  return NULL;
}

ssize_t getdelim(char **lineptr, size_t *n, int delim, FILE *stream) {
  if (lineptr == NULL || n == NULL || stream == NULL)
    return -1;

  if (*lineptr == NULL) {
    *lineptr = malloc(128);
    if (*lineptr == NULL)
      return -1;
    *n = 128;
  }

  size_t i = 0;
  int c;
  while ((c = fgetc(stream)) != EOF) {
    if (i + 1 >= *n) {
      size_t new_size = *n + 128;
      char *new_lineptr = realloc(*lineptr, new_size);
      if (new_lineptr == NULL)
        return -1;
      *lineptr = new_lineptr;
      *n = new_size;
    }

    (*lineptr)[i++] = c;
    if (c == delim)
      break;
  }

  if (i == 0)
    return -1;

  (*lineptr)[i] = '\0';
  return i;
}

ssize_t getline(char **lineptr, size_t *n, FILE *stream) {
  return getdelim(lineptr, n, '\n', stream);
}
