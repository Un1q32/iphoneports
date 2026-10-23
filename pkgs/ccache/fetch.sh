#!/bin/sh
. ../../files/dllib.sh
ver='4.14.2'
dlsrc \
    "https://github.com/ccache/ccache/archive/refs/tags/v$ver.tar.gz" \
    "ccache-$ver.tar.gz" \
    5838a08d1dd490272d7784a809040ab43cbe57ec1becfae96e7986a39cde6286 \
    "ccache-$ver"
