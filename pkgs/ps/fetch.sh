#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
for src in ps.c print.c nlist.c tasks.c keyword.c ps.h extern.h; do
    curl -L -s -o "src/$src" "https://raw.githubusercontent.com/apple-oss-distributions/adv_cmds/adv_cmds-172/ps/$src" &
done
wait
