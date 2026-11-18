#!/bin/sh
. ../../files/dllib.sh
ver='1.1.1'
dlsrc \
    "https://github.com/libimobiledevice/libtatsu/releases/download/$ver/libtatsu-$ver.tar.bz2" \
    "libtatsu-$ver.tar.gz" \
    18f471f131c1d55ccc02fa09565d870030c6ce92f737b89fe1b3849941ebb303 \
    "libtatsu-$ver"
