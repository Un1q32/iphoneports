#!/bin/sh
rm -rf "$_DESTDIR" "$_SRCDIR"
ver='1.0.29'
if [ ! -f "$_DLCACHE/libusb-$ver.tar.gz" ] ||
    [ "$(sha256sum "$_DLCACHE/libusb-$ver.tar.gz" | awk '{print $1}')" != "5977fc950f8d1395ccea9bd48c06b3f808fd3c2c961b44b0c2e6e29fc3a70a85" ]; then
    printf "Downloading source...\n"
    curl -L -# -o "$_DLCACHE/libusb-$ver.tar.gz" "https://github.com/libusb/libusb/releases/download/v$ver/libusb-$ver.tar.bz2" || exit 1
fi
printf "Unpacking source...\n"
tar -C "$_TMP" -xf "$_DLCACHE/libusb-$ver.tar.gz"
mv "$_TMP"/libusb-* "$_SRCDIR"
