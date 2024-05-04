#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/libimobiledevice/idevicerestore.git src
cd src || exit 1
git -c advice.detachedHead=false checkout 0548d9f20d2937d1e122d0b405cb60219ec4fa0f
