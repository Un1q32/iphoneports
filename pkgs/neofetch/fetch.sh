#!/bin/sh
ver=2.0.4
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
mkdir -p src
curl -L -s -o src/neofetch "https://raw.githubusercontent.com/hykilpikonna/hyfetch/refs/tags/$ver/neofetch" &
curl -L -s -o src/LICENSE.md "https://raw.githubusercontent.com/hykilpikonna/hyfetch/refs/tags/$ver/LICENSE.md"
wait
chmod 755 src/neofetch
