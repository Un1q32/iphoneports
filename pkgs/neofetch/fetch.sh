#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir -p src
curl -L -# -o src/neofetch https://raw.githubusercontent.com/hykilpikonna/hyfetch/6ac7f70c51a580de898ed4c93d779436069704ef/neofetch
chmod 755 src/neofetch
