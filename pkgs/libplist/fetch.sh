#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.bz2 https://github.com/libimobiledevice/libplist/releases/download/2.2.0/libplist-2.2.0.tar.bz2
printf "Unpacking source...\n"
tar -xf src.tar.bz2
rm src.tar.bz2
mv libplist-2.2.0 src
