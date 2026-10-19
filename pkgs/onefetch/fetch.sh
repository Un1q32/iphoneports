#!/bin/sh
. ../../files/dllib.sh
ver='3.1.0'
dlsrc \
    "https://github.com/o2sh/onefetch/archive/refs/tags/$ver.tar.gz" \
    "onefetch-$ver.tar.gz" \
    7381912c62ed1c8a3b1a443afac2fa22d8a10db8414cd44198c5d4997fab0d54 \
    "onefetch-$ver"
