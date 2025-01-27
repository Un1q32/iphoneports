#pragma once

#include_next <libproc.h>

static inline int proc_listallpids(void *buffer, int buffersize) {
  int numpids;
  numpids = proc_listpids(PROC_ALL_PIDS, (uint32_t)0, buffer, buffersize);

  if (numpids == -1)
    return -1;
  else
    return numpids / sizeof(int);
}
