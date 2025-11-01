#!/bin/sh -e
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
git clone https://github.com/libimobiledevice/ideviceinstaller.git "$_SRCDIR"
cd "$_SRCDIR"
git -c advice.detachedHead=false checkout 1431d42b568ee78161a41ed02df0de60dc1439d6
