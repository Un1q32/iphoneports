#!/bin/sh
. ../../files/dllib.sh
ver='4.4.4'
dlsrc \
    "https://github.com/Kitware/CMake/archive/refs/tags/v$ver.tar.gz" \
    "cmake-$ver.tar.gz" \
    4f6917fcdbd07517917acff9e9ce20d597a6477bdab1aab00210790620b17848 \
    "CMake-$ver"
