#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir -p src
curl -L -# -o src/neofetch https://raw.githubusercontent.com/hykilpikonna/hyfetch/54d82ff55754979ecec4b1a7dba5a48fa31a002a/neofetch
chmod 755 src/neofetch
