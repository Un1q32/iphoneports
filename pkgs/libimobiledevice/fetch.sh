#!/bin/sh
commit=5f083426b4ede24b2576f3a56eaf8ac3632c02f7
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/libimobiledevice/libimobiledevice/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "libimobiledevice-${commit}" src
