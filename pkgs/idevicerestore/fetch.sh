#!/bin/sh -e
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
git clone https://github.com/libimobiledevice/idevicerestore.git "$_SRCDIR"
cd "$_SRCDIR"
git -c advice.detachedHead=false checkout bb5591d690a057fbc6533df2617189005ea95f40
