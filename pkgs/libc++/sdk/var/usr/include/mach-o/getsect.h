#pragma once

#include_next <mach-o/getsect.h>

#if (defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__) &&                \
     __ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__ < 40000) ||                \
    (defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) &&                 \
     __ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__ < 1070)

#include <string.h>

#ifdef __LP64__

static inline uint8_t *getsectiondata(const struct mach_header_64 *mhp,
                                      const char *segname, const char *sectname,
                                      unsigned long *size) {
  struct segment_command_64 *sgp;
  struct section_64 *sp;
  uint32_t i, j;
  intptr_t slide;

  slide = 0;
  sp = 0;
  sgp = (struct segment_command_64 *)((char *)mhp +
                                      sizeof(struct mach_header_64));
  for (i = 0; i < mhp->ncmds; i++) {
    if (sgp->cmd == LC_SEGMENT_64) {
      if (strcmp(sgp->segname, "__TEXT") == 0) {
        slide = (uintptr_t)mhp - sgp->vmaddr;
      }
      if (strncmp(sgp->segname, segname, sizeof(sgp->segname)) == 0) {
        sp = (struct section_64 *)((char *)sgp +
                                   sizeof(struct segment_command_64));
        for (j = 0; j < sgp->nsects; j++) {
          if (strncmp(sp->sectname, sectname, sizeof(sp->sectname)) == 0 &&
              strncmp(sp->segname, segname, sizeof(sp->segname)) == 0) {
            *size = sp->size;
            return ((uint8_t *)(sp->addr) + slide);
          }
          sp = (struct section_64 *)((char *)sp + sizeof(struct section_64));
        }
      }
    }
    sgp = (struct segment_command_64 *)((char *)sgp + sgp->cmdsize);
  }
  return 0;
}

#else

static inline uint8_t *getsectiondata(const struct mach_header *mhp,
                                      const char *segname, const char *sectname,
                                      unsigned long *size) {
  struct segment_command *sgp;
  struct section *sp;
  uint32_t i, j;
  intptr_t slide;

  slide = 0;
  sp = 0;
  sgp = (struct segment_command *)((char *)mhp + sizeof(struct mach_header));
  for (i = 0; i < mhp->ncmds; i++) {
    if (sgp->cmd == LC_SEGMENT) {
      if (strcmp(sgp->segname, "__TEXT") == 0) {
        slide = (uintptr_t)mhp - sgp->vmaddr;
      }
      if (strncmp(sgp->segname, segname, sizeof(sgp->segname)) == 0) {
        sp = (struct section *)((char *)sgp + sizeof(struct segment_command));
        for (j = 0; j < sgp->nsects; j++) {
          if (strncmp(sp->sectname, sectname, sizeof(sp->sectname)) == 0 &&
              strncmp(sp->segname, segname, sizeof(sp->segname)) == 0) {
            *size = sp->size;
            return ((uint8_t *)(sp->addr) + slide);
          }
          sp = (struct section *)((char *)sp + sizeof(struct section));
        }
      }
    }
    sgp = (struct segment_command *)((char *)sgp + sgp->cmdsize);
  }
  return 0;
}

#endif

#endif
