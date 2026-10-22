#if MINVER_LT(1070, 40300, 0)

#include <stddef.h>

char *stpncpy(char *s1, const char *s2, size_t n) {
  char *s = s1;
  const char *p = s2;

  while (n) {
    if ((*s = *s2))
      s2++;
    ++s;
    --n;
  }
  return s1 + (s2 - p);
}

#endif
