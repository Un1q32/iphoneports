#!/bin/sh
. ../../files/dllib.sh
ver='4.4.0'
dlsrc \
    "https://cdn.openbsd.org/pub/OpenBSD/LibreSSL/libressl-$ver.tar.gz" \
    "libressl-$ver.tar.gz" \
    7d02522ad5070b9adb32eb253ecabce181184a3750cf65abac0675ee908687c1 \
    "libressl-$ver"
