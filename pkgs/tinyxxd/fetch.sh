#!/bin/sh
. ../../files/dllib.sh
ver='1.3.17'
dlsrc \
    "https://github.com/xyproto/tinyxxd/archive/refs/tags/v$ver.tar.gz" \
    "tinyxxd-$ver.tar.gz" \
    d91cc4240c90cce4ada2b3f3d410cd916b6489495451a70a572908458180f955 \
    "tinyxxd-$ver"
