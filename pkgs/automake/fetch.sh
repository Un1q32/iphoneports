#!/bin/sh
. ../../files/dllib.sh
ver='1.20'
dlsrc \
    "https://ftpmirror.gnu.org/gnu/automake/automake-$ver.tar.xz" \
    "automake-$ver.tar.xz" \
    f6f34dad4cbe395715762b0710f7c511e39bd5cf777e6b95818ccbecf7714248 \
    "automake-$ver"
