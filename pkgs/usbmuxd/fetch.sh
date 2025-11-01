#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
git clone https://github.com/libimobiledevice/usbmuxd.git src
cd src || exit 1
git -c advice.detachedHead=false checkout 0b1b233b57d581515978a09e5a4394bfa4ee4962
