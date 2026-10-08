#!/bin/sh
. ../../files/dllib.sh
ver='3.0.0'
dlsrc \
    "https://github.com/o2sh/onefetch/archive/refs/tags/$ver.tar.gz" \
    "onefetch-$ver.tar.gz" \
    2877f2473120b41a33d03cc09bcded9ff4280951dfe447c1709df45b029e6e8b \
    "onefetch-$ver"
