#!/bin/sh
. ../../files/dllib.sh
ver='1.11.0'
dlsrc \
    "https://github.com/lz4/lz4/archive/refs/tags/v$ver.tar.gz" \
    "lz4-$ver.tar.gz" \
    247e5fa64da5f7b75ee3dd3bed484076396c9ebe8254d9ccf693eb62800c5e26 \
    "lz4-$ver"
