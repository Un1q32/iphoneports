#!/bin/sh
. ../../files/dllib.sh
ver='2.22.0'
dlsrc \
    "https://github.com/danmar/cppcheck/archive/refs/tags/$ver.tar.gz" \
    "cppcheck-$ver.tar.gz" \
    d74945deb2d50393430e07596b766f8a779512c7f60dac2a30ea64e059ece57b \
    "cppcheck-$ver"
