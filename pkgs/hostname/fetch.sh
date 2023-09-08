#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/hostname.c https://raw.githubusercontent.com/apple-oss-distributions/shell_cmds/main/hostname/hostname.c
