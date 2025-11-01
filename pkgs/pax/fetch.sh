#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir "$_SRCDIR"
for src in pax.c tar.c cpio.c options.c cache.c ftree.c tables.c getoldopt.c ar_io.c pat_rep.c pax_format.c tty_subs.c ar_subs.c sel_subs.c buf_subs.c file_subs.c gen_subs.c cache.h cpio.h extern.h ftree.h options.h pat_rep.h pax.h sel_subs.h tables.h tar.h; do
    curl -L -s -o "$_SRCDIR/$src" "https://raw.githubusercontent.com/apple-oss-distributions/file_cmds/file_cmds-428/pax/$src" &
done
wait
