#!/bin/sh
. ../../files/dllib.sh
ver='1.5.5'
dlsrc \
    "https://github.com/kspalaiologos/bzip3/releases/download/$ver/bzip3-$ver.tar.zst" \
    "bzip3-$ver.tar.zst" \
    26e0eaf81668219727cc25529337277e87df989174b555a8ecc5ce61b95e76e0 \
    "bzip3-$ver"
