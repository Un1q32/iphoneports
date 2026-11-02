#!/bin/sh
. ../../files/dllib.sh
ver='1.26.0'
dlsrc \
    "https://github.com/ngtcp2/ngtcp2/releases/download/v$ver/ngtcp2-$ver.tar.xz" \
    "ngtcp2-$ver.tar.gz" \
    7804aa0fa1c39942ba322a90805824c37231f7675b08d0c3cc4332858a7b085e \
    "ngtcp2-$ver"
