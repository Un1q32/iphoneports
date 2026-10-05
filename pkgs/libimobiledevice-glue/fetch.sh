#!/bin/sh
. ../../files/dllib.sh
ver='1.3.3'
dlsrc \
    "https://github.com/libimobiledevice/libimobiledevice-glue/releases/download/$ver/libimobiledevice-glue-$ver.tar.bz2" \
    "libimobiledevice-glue-$ver.tar.bz2" \
    920ce01382a32695f49b23292b4979a03f0afd16c58e8755d8b7f41804acc1a9 \
    "libimobiledevice-glue-$ver"
