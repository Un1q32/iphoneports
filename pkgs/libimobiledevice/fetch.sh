#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/libimobiledevice/libimobiledevice.git src
cd src || exit 1
git -c advice.detachedHead=false checkout 77c727bdfeed87abd237b8840f685a1f2084ab50
