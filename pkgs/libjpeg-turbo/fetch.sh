#!/bin/sh
. ../../files/dllib.sh
ver='3.2.1'
dlsrc \
    "https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/$ver.tar.gz" \
    "libjpeg-turbo-$ver.tar.gz" \
    6f5819c51649bce2571a23b1b0cd41eae2f57fc3f8908c7ec9e7047efb65ca13 \
    "libjpeg-turbo-$ver"
