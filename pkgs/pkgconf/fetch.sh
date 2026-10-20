#!/bin/sh
. ../../files/dllib.sh
ver='3.0.10'
dlsrc \
    "https://github.com/pkgconf/pkgconf/archive/refs/tags/pkgconf-$ver.tar.gz" \
    "pkgconf-$ver.tar.gz" \
    11818a25f2730132f3b258ac8be4e82f83b9db03a1a99a6c29cd01b94fc9d310 \
    "pkgconf-pkgconf-$ver"
