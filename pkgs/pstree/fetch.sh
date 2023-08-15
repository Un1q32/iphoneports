#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -# -o src/pstree.c https://raw.githubusercontent.com/FredHucht/pstree/main/pstree.c
