#!/bin/sh
. ../../files/dllib.sh
ver='3.3.3'
dlsrc \
    "https://salsa.debian.org/apt-team/apt/-/archive/$ver/apt-$ver.tar.bz2" \
    "apt-$ver.tar.bz2" \
    2900914cefd4ee9f6f7c742d47600b27082bf2f917a58072fb9e960a2e1bb214 \
    "apt-$ver"
mkdir -p "$_SRCDIR/iphoneports-bin"
dlfile \
    "https://raw.githubusercontent.com/julian-klode/triehash/refs/tags/v0.3/triehash.pl" \
    "triehash.pl" \
    b7c196a92160a3e9db04978f00403003e4239719ab1607f4a56a6789d49276f5
cp "$_DLCACHE/triehash.pl" "$_SRCDIR/iphoneports-bin/triehash"
chmod +x "$_SRCDIR/iphoneports-bin/triehash"
