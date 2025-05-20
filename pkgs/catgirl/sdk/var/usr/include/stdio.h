#pragma once

#include_next <stdio.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 40300) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1070)

#include <stdlib.h>
#include <sys/types.h>

#define getline __iphoneports_getline
#define getdelim __iphoneports_getdelim

static inline ssize_t getdelim(char **lineptr, size_t *n, int delim,
                               FILE *stream) {
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

static inline ssize_t getline(char **lineptr, size_t *n, FILE *stream) {
  return getdelim(lineptr, n, '\n', stream);
}

#endif
