#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/hostname.c https://raw.githubusercontent.com/apple-oss-distributions/shell_cmds/shell_cmds-240.100.15/hostname/hostname.c
