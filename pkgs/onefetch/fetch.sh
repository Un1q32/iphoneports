#!/bin/sh
. ../../files/dllib.sh
ver='3.2.0'
dlsrc \
    "https://github.com/o2sh/onefetch/archive/refs/tags/$ver.tar.gz" \
    "onefetch-$ver.tar.gz" \
    6cd2822a8f118dc2799cefd4afe04f98933687695f1ffa39284d30cb58c909f2 \
    "onefetch-$ver"
