#!/bin/sh
. ../../files/dllib.sh
ver='7.1.2-34'
dlsrc \
    "https://github.com/ImageMagick/ImageMagick/archive/refs/tags/$ver.tar.gz" \
    "imagemagick-$ver.tar.gz" \
    f5163a573a1c1bff16358d0a592b2fb168ad0fd3b9dc5ff57dc7820eebc5cf79 \
    "ImageMagick-$ver"
