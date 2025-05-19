#!/bin/sh -e
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
for src in main.c ed.h io.c buf.c re.c glbl.c undo.c sub.c; do
    curl -L -s -o "src/$src" "https://raw.githubusercontent.com/apple-oss-distributions/text_cmds/text_cmds-154/ed/$src" &
done
wait
