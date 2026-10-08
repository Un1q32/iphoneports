#!/bin/sh
. ../../files/dllib.sh
ver='2.0.0'
dlsrc \
    "https://github.com/sharkdp/hyperfine/archive/refs/tags/v$ver.tar.gz" \
    "hyperfine-$ver.tar.gz" \
    f4b71df3c78e4cf752ca6fb6ebc4b025f7ea6a5ca5c48fea75f8a1fdb4c7d721 \
    "hyperfine-$ver"
