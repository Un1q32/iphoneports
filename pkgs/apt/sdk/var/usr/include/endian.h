#pragma once

#if __BYTE_ORDER == __LITTLE_ENDIAN
#define le32toh(x) (x)
#else
#define le32toh(x) __bswap_32(x)
#endif
