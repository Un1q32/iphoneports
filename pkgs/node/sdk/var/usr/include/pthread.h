#pragma once

#define _DARWIN_C_SOURCE
#include_next <pthread.h>

#include <errno.h>
#include <stdint.h>

static inline int pthread_threadid_np(pthread_t thread, uint64_t *thread_id) {
  if (!thread_id)
    return EINVAL;
  if (!thread)
    thread = pthread_self();
  *thread_id = pthread_mach_thread_np(thread);
  return 0;
}
