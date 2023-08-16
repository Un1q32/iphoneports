#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src
curl -L -# -o src/iconfix.sh https://raw.githubusercontent.com/OldWorldOrdr/icon-fix/master/iconfix.sh
chmod 755 src/iconfix.sh
