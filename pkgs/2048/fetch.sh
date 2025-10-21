#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -s -o src/2048.c https://raw.githubusercontent.com/mevdschee/2048.c/refs/tags/v1.0.3/2048.c &
curl -L -s -o src/LICENSE https://raw.githubusercontent.com/mevdschee/2048.c/refs/tags/v1.0.3/LICENSE
wait
