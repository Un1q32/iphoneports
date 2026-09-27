#!/bin/sh
. ../../files/dllib.sh
ver='8.45'
dlsrc \
    "https://downloads.sourceforge.net/project/pcre/pcre/$ver/pcre-$ver.tar.bz2" \
    "pcre-$ver.tar.bz2" \
    4dae6fdcd2bb0bb6c37b5f97c33c2be954da743985369cddac3546e3218bffb8 \
    "pcre-$ver"
