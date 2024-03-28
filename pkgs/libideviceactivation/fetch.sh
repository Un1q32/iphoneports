#!/bin/sh
commit=067c439e0b18d6f1c8a37dde791f9d91191a922e
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/libimobiledevice/libideviceactivation/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "libideviceactivation-${commit}" src
