#pragma once

#include_next <stdio.h>

static inline FILE *open_memstream(char **, size_t *) { return NULL; }
