#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/libimobiledevice/libimobiledevice.git src
cd src || exit 1
git -c advice.detachedHead=false checkout 9ccc52222c287b35e41625cc282fb882544676c6
