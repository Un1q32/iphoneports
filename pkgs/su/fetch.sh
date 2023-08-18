#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/su.c https://raw.githubusercontent.com/apple-oss-distributions/shell_cmds/shell_cmds-116/su/su.c
