#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir -p src
curl -L -# -o src/neofetch https://raw.githubusercontent.com/hykilpikonna/hyfetch/1.99.0/neofetch
chmod 755 src/neofetch
