#include <stdlib.h>

void *__compat_aligned_alloc(size_t alignment, size_t size) {
  if (alignment % sizeof(void *) != 0)
    return NULL;

  void *mem = malloc(size + alignment);
  if (mem == NULL)
    return NULL;

  char *aligned_mem =
      (char *)(((size_t)mem + alignment - 1) & ~(alignment - 1));
  if (aligned_mem == mem)
    aligned_mem += alignment;
  ((void **)aligned_mem)[-1] = mem;
  return aligned_mem;
}

void __compat_aligned_free(void *ptr) {
  if (ptr == NULL)
    return;
  free(((void **)ptr)[-1]);
}
