#!/bin/sh
. ../../files/dllib.sh
ver='2.0.4'
dlsrc \
    "https://github.com/wasmi-labs/wasmi/archive/refs/tags/v$ver.tar.gz" \
    "wasmi-$ver.tar.gz" \
    b527564fd14868005cdef774922d61f6d4832b209e918b3082fad0da4a19ca35 \
    "wasmi-$ver"
