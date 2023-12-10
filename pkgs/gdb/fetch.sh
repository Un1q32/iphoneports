#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/gdb https://raw.githubusercontent.com/OldWorldOrdr/iphone-gdb/master/gdb
