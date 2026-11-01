#!/bin/sh
. ../../files/dllib.sh
ver='7.1.2-35'
dlsrc \
    "https://github.com/ImageMagick/ImageMagick/archive/refs/tags/$ver.tar.gz" \
    "imagemagick-$ver.tar.gz" \
    40b6fefa88fe16ca5a4b3d3db5133eaebfb0157f21f98530bde8aec5dd5b0776 \
    "ImageMagick-$ver"
