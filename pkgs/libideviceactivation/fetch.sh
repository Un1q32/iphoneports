#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/libimobiledevice/libideviceactivation.git src
cd src || exit 1
git -c advice.detachedHead=false checkout 6925d58ef7994168fb9585aa6f48421149982329
