#!/bin/sh
. ../../files/dllib.sh
ver='4.5.0'
dlsrc \
    "https://github.com/Kitware/CMake/archive/refs/tags/v$ver.tar.gz" \
    "cmake-$ver.tar.gz" \
    707cd2876cc7cc7e3392a61b1c3b1e3da81472a988a11970272173ea9a896c09 \
    "CMake-$ver"
