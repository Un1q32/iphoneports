#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/libimobiledevice/libimobiledevice src --depth 1
