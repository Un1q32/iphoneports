#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir -p src
curl -L -# -o src/neofetch https://raw.githubusercontent.com/hykilpikonna/hyfetch/1211dc697881c1a5b96260e89786dbd6f133efb8/neofetch
chmod 755 src/neofetch
