#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir -p src
curl -L -# -o src/pfetch https://raw.githubusercontent.com/Un1q32/pfetch/1.5.0/pfetch
chmod 755 src/pfetch
