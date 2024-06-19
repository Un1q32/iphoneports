#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.bz2 https://github.com/libimobiledevice/libimobiledevice-glue/releases/download/1.3.0/libimobiledevice-glue-1.3.0.tar.bz2
printf "Unpacking source...\n"
tar -xf src.tar.bz2
rm src.tar.bz2
mv libimobiledevice-glue-1.3.0 src
