#!/bin/sh
. ../../files/dllib.sh
ver='4.4.5'
dlsrc \
    "https://github.com/Kitware/CMake/archive/refs/tags/v$ver.tar.gz" \
    "cmake-$ver.tar.gz" \
    ae0619a14240d5685c2fc81475a38b45e2bd4efeb594c928d9e635185f3c6338 \
    "CMake-$ver"
