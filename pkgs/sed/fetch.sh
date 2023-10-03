#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
for src in main.c compile.c misc.c process.c defs.h extern.h; do
    curl -L -s -o "src/$src" "https://raw.githubusercontent.com/apple-oss-distributions/text_cmds/text_cmds-165.0.4/sed/$src" &
done
wait
