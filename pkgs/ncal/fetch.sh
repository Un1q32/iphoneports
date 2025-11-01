#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir "$_SRCDIR"
for src in ncal.c calendar.c calendar.h easter.c; do
    curl -L -s -o "$_SRCDIR/$src" "https://raw.githubusercontent.com/apple-oss-distributions/misc_cmds/misc_cmds-44/ncal/$src" &
done
wait
