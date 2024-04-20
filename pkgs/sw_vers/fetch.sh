#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/sw_vers.c https://opensource.apple.com/source/DarwinTools/DarwinTools-1/sw_vers.c
