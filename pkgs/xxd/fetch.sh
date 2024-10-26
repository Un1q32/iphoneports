#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -# -o src/xxd.c https://raw.githubusercontent.com/vim/vim/c73fc86bf8fe318aab41900dd92e380143211cda/src/xxd/xxd.c
