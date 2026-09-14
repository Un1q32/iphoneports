#!/bin/sh
. ../../files/dllib.sh
ver='2.0.0'
dlsrc \
    "https://github.com/wasmi-labs/wasmi/archive/refs/tags/v$ver.tar.gz" \
    "wasmi-$ver.tar.gz" \
    089ac412a1f8ac701d87c3d93e4b3b793972d13c079d1fa6e67a45f34ded3f50 \
    "wasmi-$ver"
