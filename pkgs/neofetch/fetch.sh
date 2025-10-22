#!/bin/sh
version=ba88581ed43497b6ce2583ee13c1e961b8eae4d8
rm -rf pkg src
printf "Downloading source...\n"
mkdir -p src
curl -L -s -o src/neofetch "https://raw.githubusercontent.com/hykilpikonna/hyfetch/$version/neofetch" &
curl -L -s -o src/LICENSE.md "https://raw.githubusercontent.com/hykilpikonna/hyfetch/$version/LICENSE.md"
wait
chmod 755 src/neofetch
