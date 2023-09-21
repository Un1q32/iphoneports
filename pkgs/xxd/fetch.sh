#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -# -o src/xxd.c https://raw.githubusercontent.com/vim/vim/233f956bd43279db1fb4d017acb4e56a1504addf/src/xxd/xxd.c
