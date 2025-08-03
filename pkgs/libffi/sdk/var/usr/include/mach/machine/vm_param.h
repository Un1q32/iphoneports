#pragma once

#include_next <mach/machine/vm_param.h>

#ifndef PAGE_MAX_SHIFT
#define PAGE_MAX_SHIFT 14
#endif
#ifndef PAGE_MAX_SIZE
#define PAGE_MAX_SIZE (1 << PAGE_MAX_SHIFT)
#endif
#ifndef PAGE_MAX_MASK
#define PAGE_MAX_MASK (PAGE_MAX_SIZE - 1)
#endif
