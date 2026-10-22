#if MINVER_LT(1070, 40300, 0)

#include <dlfcn.h>
#include <errno.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

ssize_t getdelim(char **buf, size_t *bufsiz, int delim, FILE *file) {

#if MAXVER_GE(1070, 40300, 0)

  static bool init = false;
  static ssize_t (*func)(char **, size_t *, int, FILE *);

  if (!init) {
    func = (ssize_t (*)(char **, size_t *, int, FILE *))dlsym(RTLD_NEXT,
                                                              "getdelim");
    init = true;
  }

  if (func)
    return func(buf, bufsiz, delim, file);

#endif

  if (buf == NULL || bufsiz == NULL) {
    errno = EINVAL;
    return -1;
  }

  if (*buf == NULL || *bufsiz == 0) {
    char *nbuf = realloc(*buf, BUFSIZ);
    if (nbuf == NULL)
      return -1;
    *buf = nbuf;
    *bufsiz = BUFSIZ;
  }

  flockfile(file);

  char *ptr;
  ssize_t ret;
  for (ptr = *buf;;) {
    int c = getc_unlocked(file);
    if (c == -1) {
      if (feof(file) && ptr != *buf) {
        *ptr = '\0';
        ret = ptr - *buf;
      } else
        ret = -1;
      break;
    }

    if ((size_t)(ptr - *buf) + 2 > *bufsiz) {
      char *nbuf;
      size_t nbufsiz;
      ssize_t d = ptr - *buf;

      if (*bufsiz > (size_t)SSIZE_MAX / 2) {
        errno = EOVERFLOW;
        /*
         * Accessing private libc stuff here, works on tiger through lion so
         * even if Apple breaks it, new Darwin versions will be using Apple's
         * getdelim anyway.
         */
        file->_flags |= __SERR;
        ret = -1;
        break;
      }
      nbufsiz = *bufsiz * 2;
      if ((nbuf = realloc(*buf, nbufsiz)) == NULL) {
        /* Same as above comment */
        file->_flags |= __SERR;
        ret = -1;
        break;
      }
      *buf = nbuf;
      *bufsiz = nbufsiz;
      ptr = nbuf + d;
    }

    *ptr++ = c;
    if (c == delim) {
      *ptr = '\0';
      ret = ptr - *buf;
      break;
    }
  }

  int err = errno;
  funlockfile(file);
  if (ret == -1)
    errno = err;
  return ret;
}

ssize_t getline(char **buf, size_t *bufsiz, FILE *file) {
  return getdelim(buf, bufsiz, '\n', file);
}

#endif
