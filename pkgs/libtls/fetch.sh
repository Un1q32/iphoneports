#!/bin/sh
. ../../files/dllib.sh
ver='4.4.1'
dlsrc \
    "https://cdn.openbsd.org/pub/OpenBSD/LibreSSL/libressl-$ver.tar.gz" \
    "libressl-$ver.tar.gz" \
    290cdf1b53c086255dc302f118b98602a444e9ae6d11e9bfdd8c9b1b60aa3a22 \
    "libressl-$ver"
