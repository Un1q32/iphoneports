#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -# -o src/pstree.c https://raw.githubusercontent.com/FredHucht/pstree/ec7999a748f2ce167a36756f11df0c5d8101170e/pstree.c
