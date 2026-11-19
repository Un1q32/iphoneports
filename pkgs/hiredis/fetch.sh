#!/bin/sh
. ../../files/dllib.sh
ver='1.5.1'
dlsrc \
    "https://github.com/redis/hiredis/archive/refs/tags/v$ver.tar.gz" \
    "hiredis-$ver.tar.gz" \
    f5ec19151c0f4f15ca018c22b17b6f6739a672a4fc0c085b692aef69a154ebef \
    "hiredis-$ver"
