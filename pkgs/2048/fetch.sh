#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -# -o src/2048.c https://raw.githubusercontent.com/mevdschee/2048.c/6c04517bb59c28f3831585da338f021bc2ea86d6/2048.c
