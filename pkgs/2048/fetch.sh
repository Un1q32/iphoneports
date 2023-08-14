#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -# -o src/2048.c https://raw.githubusercontent.com/mevdschee/2048.c/main/2048.c
