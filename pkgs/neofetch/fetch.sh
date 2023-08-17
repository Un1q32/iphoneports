#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir -p src
curl -L -# -o src/neofetch https://raw.githubusercontent.com/OldWorldOrdr/hyfetch/29cbbae9744e5cc4e978208c0881e278b7a93374/neofetch
chmod 755 src/neofetch
