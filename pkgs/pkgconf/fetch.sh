#!/bin/sh
. ../../files/dllib.sh
ver='3.0.8'
dlsrc \
    "https://github.com/pkgconf/pkgconf/archive/refs/tags/pkgconf-$ver.tar.gz" \
    "pkgconf-$ver.tar.gz" \
    44f67cdda8192efecd9be9f8df2fe54f087f8c84062ddff0027133f94543bf8a \
    "pkgconf-pkgconf-$ver"
