#!/bin/sh
. ../../files/dllib.sh
ver='3.3.6'
dlsrc \
    "https://salsa.debian.org/apt-team/apt/-/archive/$ver/apt-$ver.tar.bz2" \
    "apt-$ver.tar.bz2" \
    e1b70db67b35f1415b5f225e5b708e2a96cd6b1fc90f9124e4aa7ac87834dc42 \
    "apt-$ver"
mkdir -p "$_SRCDIR/iphoneports-bin"
dlfile \
    "https://raw.githubusercontent.com/julian-klode/triehash/refs/tags/v0.3/triehash.pl" \
    "triehash.pl" \
    b7c196a92160a3e9db04978f00403003e4239719ab1607f4a56a6789d49276f5
cp "$_DLCACHE/triehash.pl" "$_SRCDIR/iphoneports-bin/triehash"
chmod +x "$_SRCDIR/iphoneports-bin/triehash"
