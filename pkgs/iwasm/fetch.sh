#!/bin/sh
. ../../files/dllib.sh
ver='2.4.6'
dlsrc \
    "https://github.com/bytecodealliance/wasm-micro-runtime/archive/refs/tags/WAMR-$ver.tar.gz" \
    "wamr-$ver.tar.gz" \
    6a8de3f74671a72698b4bd61a96c1ce8966db077b2adad7b720757cfd9caff62 \
    "wasm-micro-runtime-WAMR-$ver"
