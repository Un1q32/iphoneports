#!/bin/sh
rm -rf package source
printf "Downloading source...\n"
mkdir source
curl -L -# -o source/iconfix.sh https://raw.githubusercontent.com/OldWorldOrdr/icon-fix/master/iconfix.sh
chmod 755 source/iconfix.sh
