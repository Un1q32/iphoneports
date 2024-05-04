#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/libimobiledevice/ideviceinstaller.git src
cd src || exit 1
git -c advice.detachedHead=false checkout 490058e1df180aaab55a808d0cab6efa706a658f
