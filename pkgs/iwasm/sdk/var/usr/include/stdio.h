#pragma once

#include_next <stdio.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 80000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 101000)

#include <errno.h>
#include <fcntl.h>
#include <string.h>
#include <sys/stat.h>

#define renameat __iphoneports_renameat

static int renameat(int olddirfd, const char *oldpath, int newdirfd,
                    const char *newpath) {

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ >= 20000) ||               \
    !defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__)

  static bool init = false;
  static int (*func)(int, const char *, int, const char *);

  if (!init) {
    func = (int (*)(int, const char *, int, const char *))dlsym(RTLD_NEXT,
                                                                "renameat");
    init = true;
  }

  if (func)
    return func(olddirfd, oldpath, newdirfd, newpath);

#endif

  /*
   * This has race conditions, they could be mitigated by using pthread_fchdir,
   * but that would require writing a really long function and I don't wanna do
   * that.
   */
  if (oldpath[0] != '/' && olddirfd != AT_FDCWD) {
    struct stat st;
    if (fstat(olddirfd, &st) == -1)
      return -1;
    if (!S_ISDIR(st.st_mode)) {
      errno = ENOTDIR;
      return -1;
    }

    char oldfdpath[PATH_MAX + strlen(oldpath) + 2];
    fcntl(olddirfd, F_GETPATH, oldfdpath);
    strcat(oldfdpath, "/");
    strcat(oldfdpath, oldpath);
    oldpath = oldfdpath;
  }
  if (newpath[0] != '/' && newdirfd != AT_FDCWD) {
    struct stat st;
    if (fstat(newdirfd, &st) == -1)
      return -1;
    if (!S_ISDIR(st.st_mode)) {
      errno = ENOTDIR;
      return -1;
    }

    char newfdpath[PATH_MAX + strlen(newpath) + 2];
    fcntl(newdirfd, F_GETPATH, newfdpath);
    strcat(newfdpath, "/");
    strcat(newfdpath, newpath);
    newpath = newfdpath;
  }
  return rename(oldpath, newpath);
}

#endif

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
  if (!lineptr || !n || !stream) {
    errno = EINVAL;
    return -1;
  }

  if (*lineptr == NULL) {
    *lineptr = (char *)malloc(128);
    if (*lineptr == NULL)
      return -1;
    *n = 128;
  }

  size_t i = 0;
  int c;
  while (c = fgetc(stream) != EOF) {
    if (i + 1 >= *n) {
      size_t new_size = *n + 128;
      char *new_lineptr = (char *)realloc(*lineptr, new_size);
      if (!new_lineptr)
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
