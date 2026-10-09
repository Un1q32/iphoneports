#!/bin/sh
. ../../files/dllib.sh
ver='1.4.85'
dlsrc \
    "https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-$ver.tar.xz" \
    "lighttpd-$ver.tar.gz" \
    18de51b393bac4a6827879e1a7ff377c169e414bae92cd245091d80fc2601d13 \
    "lighttpd-$ver"
