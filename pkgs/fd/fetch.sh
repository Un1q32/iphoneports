#!/bin/sh
. ../../files/dllib.sh
ver='10.5.2'
dlsrc \
    "https://github.com/sharkdp/fd/archive/refs/tags/v$ver.tar.gz" \
    "fd-$ver.tar.gz" \
    8991b6504cac33c00528050622dfe3f2a0db1be1a6faf99f69b46d1a8f737dc5 \
    "fd-$ver"
