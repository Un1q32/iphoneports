#!/bin/sh
commit=9649448434ab5c674d2cc11f76e69e6ee5e9dc09
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/libimobiledevice/libimobiledevice/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "libimobiledevice-${commit}" src
