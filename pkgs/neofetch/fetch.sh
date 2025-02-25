#!/bin/sh
commit=8a536c30f07a1cc599285dc14f6020b0d7d9e44d
rm -rf pkg src
printf "Downloading source...\n"
mkdir -p src
curl -L -s -o src/neofetch "https://raw.githubusercontent.com/hykilpikonna/hyfetch/$commit/neofetch" &
curl -L -s -o src/LICENSE.md "https://raw.githubusercontent.com/hykilpikonna/hyfetch/$commit/LICENSE.md"
wait
chmod 755 src/neofetch
