#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
mkdir source
curl -# -o source/2048.c https://raw.githubusercontent.com/mevdschee/2048.c/main/2048.c
