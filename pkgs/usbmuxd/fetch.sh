#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
git clone https://github.com/libimobiledevice/usbmuxd src --depth 1
