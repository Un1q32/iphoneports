#!/bin/sh
. ../../files/dllib.sh
ver='1.6.0'
dlsrc \
    "https://github.com/meta/zstd/releases/download/v1.6.0/zstd-1.6.0.tar.zst" \
    "zstd-$ver.tar.zst" \
    2ca30d45c7a61f255e17024373f7fe75b6403b2ade6b21220c1472964d8a466a \
    "zstd-$ver"
