#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir -p src
curl -L -# -o src/neofetch https://raw.githubusercontent.com/hykilpikonna/hyfetch/8a536c30f07a1cc599285dc14f6020b0d7d9e44d/neofetch
chmod 755 src/neofetch
