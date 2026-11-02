#!/bin/sh
. ../../files/dllib.sh
ver='1.71.0'
dlsrc \
    "https://github.com/nghttp2/nghttp2/releases/download/v$ver/nghttp2-$ver.tar.xz" \
    "nghttp2-$ver.tar.gz" \
    c0f55121d88650e4b9227aec28cebaf664d2417ca60fe70be0f8d38829f52116 \
    "nghttp2-$ver"
