#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir "$_SRCDIR"
for src in gzip.c unbzip2.c zuncompress.c unpack.c unxz.c unlz.c gzexe zdiff zforce zmore znew; do
    curl -L -s -o "$_SRCDIR/$src" "https://raw.githubusercontent.com/apple-oss-distributions/file_cmds/file_cmds-448.0.3/gzip/$src" &
done
wait
