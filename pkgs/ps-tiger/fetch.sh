#!/bin/sh -e
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir "$_SRCDIR"
for src in ps.c print.c nlist.c tasks.c keyword.c ps.h extern.h; do
    curl -L -s -o "$_SRCDIR/$src" "https://raw.githubusercontent.com/apple-oss-distributions/adv_cmds/adv_cmds-119/ps.tproj/$src" &
done
wait
