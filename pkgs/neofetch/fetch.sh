#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir -p src
curl -L -# -o src/neofetch https://raw.githubusercontent.com/OldWorldOrdr/hyfetch/fix-sed/neofetch
chmod 755 src/neofetch
