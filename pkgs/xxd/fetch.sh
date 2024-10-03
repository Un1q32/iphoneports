#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -# -o src/xxd.c https://raw.githubusercontent.com/vim/vim/150227258d3f44b91cf21f527e4778f6cc38b160/src/xxd/xxd.c
