#!/bin/sh
. ../../files/dllib.sh
ver='2.0.2'
dlsrc \
    "https://github.com/wasmi-labs/wasmi/archive/refs/tags/v$ver.tar.gz" \
    "wasmi-$ver.tar.gz" \
    c500e2040abd2692f48e8894b53cf8e838a8b941bc0d249c2363faa1803fc7ad \
    "wasmi-$ver"
