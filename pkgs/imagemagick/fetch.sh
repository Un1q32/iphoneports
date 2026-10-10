#!/bin/sh
. ../../files/dllib.sh
ver='7.1.2-33'
dlsrc \
    "https://github.com/ImageMagick/ImageMagick/archive/refs/tags/$ver.tar.gz" \
    "imagemagick-$ver.tar.gz" \
    c768ff077cccff1b682aa56653b54247b268752427ca998992b24cc7c597d9e7 \
    "ImageMagick-$ver"
