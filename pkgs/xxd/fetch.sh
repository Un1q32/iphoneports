#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -# -o src/xxd.c https://raw.githubusercontent.com/vim/vim/6e6aff0f7ad2a2c9033724738e66dfdbb9e4c2ec/src/xxd/xxd.c
