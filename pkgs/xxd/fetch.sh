#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -# -o src/xxd.c https://raw.githubusercontent.com/vim/vim/4b9fa957125e33951a4a830414ccb70172976397/src/xxd/xxd.c
