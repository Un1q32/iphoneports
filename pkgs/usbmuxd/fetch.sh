#!/bin/sh
commit=360619c5f721f93f0b9d8af1a2df0b926fbcf281
rm -rf pkg src
printf "Downloading source...\n"
curl -L -# -o src.tar.gz "https://github.com/libimobiledevice/usbmuxd/archive/${commit}.tar.gz"
printf "Unpacking source...\n"
tar -xf src.tar.gz
rm src.tar.gz
mv "usbmuxd-${commit}" src
