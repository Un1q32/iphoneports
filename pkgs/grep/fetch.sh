#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
for src in grep.c queue.c util.c file.c grep.h; do
    curl -L -s -o "src/$src" "https://raw.githubusercontent.com/apple-oss-distributions/text_cmds/text_cmds-165.0.4/grep/$src" &
done
wait
