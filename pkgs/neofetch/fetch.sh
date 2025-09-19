#!/bin/sh
version=ac81ef3551a8070e4ec118ee56379c263a48469e
rm -rf pkg src
printf "Downloading source...\n"
mkdir -p src
curl -L -s -o src/neofetch "https://raw.githubusercontent.com/Un1q32/hyfetch/$version/neofetch" &
curl -L -s -o src/LICENSE.md "https://raw.githubusercontent.com/Un1q32/hyfetch/$version/LICENSE.md"
wait
chmod 755 src/neofetch
