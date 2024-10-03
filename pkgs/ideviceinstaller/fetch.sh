#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/libimobiledevice/ideviceinstaller.git src
cd src || exit 1
git -c advice.detachedHead=false checkout 1431d42b568ee78161a41ed02df0de60dc1439d6
