#!/bin/sh
. ../../files/dllib.sh
ver='1.19.0'
dlsrc \
    "https://github.com/ngtcp2/nghttp3/releases/download/v$ver/nghttp3-$ver.tar.xz" \
    "nghttp3-$ver.tar.gz" \
    228e17f5cc3d4de7bfced9912bd09de30e7f45741cc47503cf88d3fa9209e155 \
    "nghttp3-$ver"
