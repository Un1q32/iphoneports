#!/bin/sh
. ../../files/dllib.sh
ver='1.11.1'
dlsrc \
    "https://github.com/lz4/lz4/archive/refs/tags/v$ver.tar.gz" \
    "lz4-$ver.tar.gz" \
    683fed08a844ad012196381e40badf80c0bbe4962959761416d41c9e67d77ec7 \
    "lz4-$ver"
