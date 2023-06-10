#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
mkdir -p source
curl -L -# -o source/neofetch https://raw.githubusercontent.com/hykilpikonna/hyfetch/1.4.9/neofetch
chmod 755 source/neofetch
