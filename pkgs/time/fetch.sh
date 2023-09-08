#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/time.c https://raw.githubusercontent.com/apple-oss-distributions/shell_cmds/shell_cmds-207.11.1/time/time.c
