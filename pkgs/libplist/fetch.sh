#!/bin/sh
. ../../files/dllib.sh
ver='2.8.1'
dlsrc \
    "https://github.com/libimobiledevice/libplist/releases/download/$ver/libplist-$ver.tar.bz2" \
    "libplist-$ver.tar.bz2" \
    2a1792e5820e1657c173735fde75baeebd6dd967d2ac47be1e3891ddc64ebefa \
    "libplist-$ver"
