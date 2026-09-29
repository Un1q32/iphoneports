#!/bin/sh
. ../../files/dllib.sh
ver='3.6.5'
dlsrc \
    "https://github.com/openssl/openssl/releases/download/openssl-$ver/openssl-$ver.tar.gz" \
    "openssl-$ver.tar.gz" \
    a2157c2830efdec3788939b00c9b0638306d3f0bbb76dc4832ee503bb397df98 \
    "openssl-$ver"
