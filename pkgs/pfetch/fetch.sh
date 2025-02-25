#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir -p src
curl -L -s -o src/pfetch https://raw.githubusercontent.com/Un1q32/pfetch/1.7.1/pfetch &
curl -L -s -o src/LICENSE https://raw.githubusercontent.com/Un1q32/pfetch/1.7.1/LICENSE
wait
chmod 755 src/pfetch
