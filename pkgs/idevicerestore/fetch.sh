#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/libimobiledevice/idevicerestore.git src
cd src || exit 1
git -c advice.detachedHead=false checkout 511261e12d23d80cc3c08290022380b8d3411f9c
