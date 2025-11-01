#!/bin/sh -e
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
git clone https://github.com/libimobiledevice/libimobiledevice.git "$_SRCDIR"
cd "$_SRCDIR"
git -c advice.detachedHead=false checkout c8cdf20fe20b0c46ed7d9a9386bed03301ddbfa5
