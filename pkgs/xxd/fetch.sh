#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -# -o src/xxd.c https://raw.githubusercontent.com/vim/vim/4390d872b6c9498527a43fc7c30a5384f2e1db12/src/xxd/xxd.c
