#pragma once

#include_next <sys/mman.h>

#ifndef MAP_JIT
#define MAP_JIT 0x0800
#endif
