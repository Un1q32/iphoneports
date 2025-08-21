#!/bin/sh
version=2.0.1
rm -rf pkg src
printf "Downloading source...\n"
mkdir -p src
curl -L -s -o src/neofetch "https://raw.githubusercontent.com/hykilpikonna/hyfetch/refs/tags/$version/neofetch" &
curl -L -s -o src/LICENSE.md "https://raw.githubusercontent.com/hykilpikonna/hyfetch/refs/tags/$version/LICENSE.md"
wait
chmod 755 src/neofetch
