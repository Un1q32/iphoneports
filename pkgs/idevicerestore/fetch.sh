#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/libimobiledevice/idevicerestore.git src
cd src || exit 1
git -c advice.detachedHead=false checkout bb5591d690a057fbc6533df2617189005ea95f40
