#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir -p src
ver=1.9.1
curl -L -s -o src/pfetch "https://raw.githubusercontent.com/Un1q32/pfetch/$ver/pfetch" &
curl -L -s -o src/LICENSE "https://raw.githubusercontent.com/Un1q32/pfetch/$ver/LICENSE"
wait
chmod 755 src/pfetch
