#!/bin/sh
. ../../files/dllib.sh
ver='1.21.0'
dlsrc \
    "https://github.com/sharkdp/hyperfine/archive/refs/tags/v$ver.tar.gz" \
    "hyperfine-$ver.tar.gz" \
    aee01125074fd5a6a556818db7bba0577edae94cbe85165daae0e778aa28348d \
    "hyperfine-$ver"
