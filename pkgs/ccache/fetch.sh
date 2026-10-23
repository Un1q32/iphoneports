#!/bin/sh
. ../../files/dllib.sh
ver='4.14.1'
dlsrc \
    "https://github.com/ccache/ccache/archive/refs/tags/v$ver.tar.gz" \
    "ccache-$ver.tar.gz" \
    198e4b6a5ae13a16927914a29420e77a7d625ad39488dd74b0860c30115b2f29 \
    "ccache-$ver"
