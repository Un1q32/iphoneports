#if ((defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) ||               \
      defined(__ENVIRONMENT_TV_OS_VERSION_MIN_REQUIRED__)) &&                  \
     __ENVIRONMENT_OS_VERSION_MIN_REQUIRED__ < 180400) ||                      \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 150400) ||                \
    (defined(__ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_WATCH_OS_VERSION_MIN_REQUIRED__ < 110400)

#include <string.h>

char *strchrnul(const char *s, int c) {
  c = (unsigned char)c;
  if (!c)
    return (char *)s + strlen(s);

  for (; *s && *(unsigned char *)s != c; s++)
    ;
  return (char *)s;
}

#endif
