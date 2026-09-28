#!/bin/sh
. ../../files/dllib.sh
ver='10.5p1'
dlsrc \
    "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-$ver.tar.gz" \
    "openssh-$ver.tar.gz" \
    d44d28a839ea9daf969cc69150fde59910b2b39361dad81a3bd6cbd19218db11 \
    "openssh-$ver"
