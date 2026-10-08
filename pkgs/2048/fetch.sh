#!/bin/sh
. ../../files/dllib.sh
ver='1.0.5'
dlsrc \
    "https://github.com/mevdschee/2048.c/archive/refs/tags/v$ver.tar.gz" \
    "2048-$ver.tar.gz" \
    83b9008dc77d7ab2ad721d7316551fb015dce97c40337a354040fe45d8296fd4 \
    "2048.c-$ver"
