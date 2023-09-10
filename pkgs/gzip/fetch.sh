#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
for src in gzip.c unbzip2.c zuncompress.c unpack.c unxz.c unlz.c futimens.c gzexe zdiff zforce zmore znew; do
    curl -L -s -o "src/$src" "https://raw.githubusercontent.com/apple-oss-distributions/file_cmds/file_cmds-400/gzip/$src" &
done
wait
