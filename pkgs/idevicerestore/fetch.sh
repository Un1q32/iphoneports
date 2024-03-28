#!/bin/sh
commit=e4a5ac4114177293e3a1b555ee767377b21d4432
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/libimobiledevice/idevicerestore/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "idevicerestore-${commit}" src
