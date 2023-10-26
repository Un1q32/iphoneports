#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -# -o src/xxd.c https://raw.githubusercontent.com/vim/vim/c4a403860353ff35dc47e2a52818e771fa228083/src/xxd/xxd.c
