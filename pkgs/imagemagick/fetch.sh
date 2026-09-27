#!/bin/sh
. ../../files/dllib.sh
ver='7.1.2-32'
dlsrc \
    "https://github.com/ImageMagick/ImageMagick/archive/refs/tags/$ver.tar.gz" \
    "imagemagick-$ver.tar.gz" \
    940e349f0ef394e658fd57400b83d1d7a81b954f6e7bdbfbfad31b2718c10add \
    "ImageMagick-$ver"
