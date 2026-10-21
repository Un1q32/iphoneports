#!/bin/sh
. ../../files/dllib.sh
ver='1.2.1'
dlsrc \
    "https://github.com/google/brotli/archive/refs/tags/v$ver.tar.gz" \
    "brotli-$ver.tar.gz" \
    98d35d11a78dc453aebb7d10c3748f3f73ff78c8267c0dc697b8631f67bf7e8f \
    "brotli-$ver"
