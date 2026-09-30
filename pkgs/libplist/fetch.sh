#!/bin/sh
. ../../files/dllib.sh
ver='2.8.0'
dlsrc \
    "https://github.com/libimobiledevice/libplist/releases/download/$ver/libplist-$ver.tar.bz2" \
    "libplist-$ver.tar.bz2" \
    b1f59f7634c58b2481325a23ff4e3bf51574a42d868cbe466d2b39b04550752a \
    "libplist-$ver"
