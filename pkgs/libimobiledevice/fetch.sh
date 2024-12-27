#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/libimobiledevice/libimobiledevice.git src
cd src || exit 1
git -c advice.detachedHead=false checkout c8cdf20fe20b0c46ed7d9a9386bed03301ddbfa5
