#!/bin/sh
. ../../files/dllib.sh
ver='2.8.1'
dlsrc \
    "https://ftpmirror.gnu.org/gnu/patch/patch-$ver.tar.xz" \
    "patch-$ver.tar.gz" \
    3240c7959c5347c8ed347e3c4201c0337bf4240d5cf09d68889e58eeaba30e17 \
    "patch-$ver"
