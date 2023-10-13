#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/OldWorldOrdr/icon-fix.git src --depth 1
