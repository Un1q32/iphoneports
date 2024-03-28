#!/bin/sh
commit=22872c3571b8d2646a9fbb74ec1d7e186941053d
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/libimobiledevice/ideviceinstaller/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "ideviceinstaller-${commit}" src
