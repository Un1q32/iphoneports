#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -# -o src/xxd.c https://raw.githubusercontent.com/vim/vim/184f71cc6868a240dc872ed2852542bbc1d43e28/src/xxd/xxd.c
