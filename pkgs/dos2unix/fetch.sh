#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.5.0.tar.gz
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv dos2unix-7.5.0 src
