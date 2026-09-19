#!/bin/sh
. ../../files/dllib.sh
ver='0.8.4'
dlsrc \
    "https://github.com/Cyan4973/xxHash/archive/refs/tags/v$ver.tar.gz" \
    "xxhash-$ver.tar.gz" \
    5738270935e7c3d38a79b3adf7c9692566ce7895a25f67de43ad52ab504acd32 \
    "xxHash-$ver"
