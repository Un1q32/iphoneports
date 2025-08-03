#pragma once

#include_next <mach/machine/vm_param.h>

#define PAGE_MAX_SHIFT 14
#define PAGE_MAX_SIZE (1 << PAGE_MAX_SHIFT)
#define PAGE_MAX_MASK (PAGE_MAX_SIZE - 1)

#define PAGE_MIN_SHIFT 12
#define PAGE_MIN_SIZE (1 << PAGE_MIN_SHIFT)
#define PAGE_MIN_MASK (PAGE_MIN_SIZE - 1)
