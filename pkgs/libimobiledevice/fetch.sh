#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/libimobiledevice/libimobiledevice.git src
cd src || exit 1
git -c advice.detachedHead=false checkout 881102944edf36abc98539b10d13e2375fda88cf
