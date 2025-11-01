#!/bin/sh -e
rm -rf "$_DESTDIR" "$_SRCDIR"
printf "Downloading source...\n"
git clone https://github.com/libimobiledevice/libideviceactivation.git "$_SRCDIR"
cd "$_SRCDIR"
git -c advice.detachedHead=false checkout ecc10ef8048c6591b936c5ca1b0971157087e6b2
