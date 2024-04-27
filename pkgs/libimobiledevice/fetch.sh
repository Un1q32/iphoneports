#!/bin/sh
commit=f2d3d40487a5209cb7dfae5367fb71f3940e3ab7
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/libimobiledevice/libimobiledevice/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "libimobiledevice-${commit}" src
