#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.bz2 https://github.com/libimobiledevice/idevicerestore/releases/download/1.0.0/idevicerestore-1.0.0.tar.bz2
printf "Unpacking source...\n"
tar -xf src.tar.bz2
rm src.tar.bz2
mv idevicerestore-1.0.0 src
