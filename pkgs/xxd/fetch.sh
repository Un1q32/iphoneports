#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -# -o src/xxd.c https://raw.githubusercontent.com/vim/vim/00221487731ea1868c57259c7aa0eb713cd7ade7/src/xxd/xxd.c
