#!/bin/sh
. ../../files/dllib.sh
ver='1.23.11'
dlsrc \
    "https://salsa.debian.org/dpkg-team/dpkg/-/archive/$ver/dpkg-$ver.tar.bz2" \
    "dpkg-$ver.tar.bz2" \
    e4f1ddde2a1c0fd59c51079a98129ff9c146f8014d33b55755cf150952c22075 \
    "dpkg-$ver"
printf '%s\n' "$ver" > "$_SRCDIR/.dist-version"
