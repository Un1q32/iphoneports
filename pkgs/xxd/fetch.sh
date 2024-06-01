#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -# -o src/xxd.c https://raw.githubusercontent.com/vim/vim/67797191e039196128c69ba1538ccaf2a4711323/src/xxd/xxd.c
