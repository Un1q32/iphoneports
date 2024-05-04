#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/libimobiledevice/usbmuxd.git src
cd src || exit 1
git -c advice.detachedHead=false checkout 360619c5f721f93f0b9d8af1a2df0b926fbcf281
