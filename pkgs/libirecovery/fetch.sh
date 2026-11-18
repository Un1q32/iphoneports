#!/bin/sh
. ../../files/dllib.sh
ver='1.4.0'
dlsrc \
    "https://github.com/libimobiledevice/libirecovery/releases/download/$ver/libirecovery-$ver.tar.bz2" \
    "libirecovery-$ver.tar.gz" \
    ea358430fdcedc00ae7d5764b3d03737f7345c91364fb91271bc6ceeee5d9cac \
    "libirecovery-$ver"
