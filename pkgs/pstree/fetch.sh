#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
mkdir source
curl -# -o source/pstree.c https://raw.githubusercontent.com/FredHucht/pstree/main/pstree.c
