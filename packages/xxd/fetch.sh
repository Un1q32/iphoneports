#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
mkdir source
curl -# -o source/xxd.c https://raw.githubusercontent.com/vim/vim/master/src/xxd/xxd.c
