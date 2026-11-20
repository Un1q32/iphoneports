#!/bin/sh
. ../../files/dllib.sh
ver='9.1'
dlsrc \
    "https://ffmpeg.org/releases/ffmpeg-$ver.tar.xz" \
    "ffmpeg-$ver.tar.xz" \
    1a4d394ae63d190a526cd052eb4415c156b5c5e2df37efab41a7de0b8fde2433 \
    "ffmpeg-$ver"
