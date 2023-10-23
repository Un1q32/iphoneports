#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -# -o src/xxd.c https://raw.githubusercontent.com/vim/vim/7879bc5c13311c1fb6497776ed7804400852460a/src/xxd/xxd.c
