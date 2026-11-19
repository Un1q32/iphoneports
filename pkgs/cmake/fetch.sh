#!/bin/sh
. ../../files/dllib.sh
ver='4.5.1'
dlsrc \
    "https://github.com/Kitware/CMake/archive/refs/tags/v$ver.tar.gz" \
    "cmake-$ver.tar.gz" \
    eef5bb9bf924c53eeca8b40b537cb45e3505b358bfeb65e5d628fbfabcda178f \
    "CMake-$ver"
