#!/bin/sh
. ../../files/dllib.sh
ver='1.0.29'
dlsrc \
    "https://github.com/libusb/libusb/releases/download/v$ver/libusb-$ver.tar.bz2" \
    "libusb-$ver.tar.bz2" \
    5977fc950f8d1395ccea9bd48c06b3f808fd3c2c961b44b0c2e6e29fc3a70a85 \
    "libusb-$ver"
