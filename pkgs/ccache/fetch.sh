#!/bin/sh
. ../../files/dllib.sh
ver='4.14.3'
dlsrc \
    "https://github.com/ccache/ccache/archive/refs/tags/v$ver.tar.gz" \
    "ccache-$ver.tar.gz" \
    f769f9e3ad7fc9e8faf68bcc4f63ba52f246df49bb378924b2529d6f05b76161 \
    "ccache-$ver"
