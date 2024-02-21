#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/gdb https://raw.githubusercontent.com/Un1q32/iphone-gdb/master/gdb
