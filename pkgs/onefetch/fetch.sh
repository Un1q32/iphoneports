#!/bin/sh
. ../../files/dllib.sh
ver='3.3.0'
dlsrc \
    "https://github.com/o2sh/onefetch/archive/refs/tags/$ver.tar.gz" \
    "onefetch-$ver.tar.gz" \
    bf9122e9e28a6d645092b20b8b931fe3eba08a94fe21679169ef39f016afe892 \
    "onefetch-$ver"
