#if MINVER_LT(101000, 80000, 0)

#include <stdlib.h>

int32_t CCRandomGenerateBytes(void *buf, size_t size) {
  arc4random_buf(buf, size);
  return 0;
}

#endif
