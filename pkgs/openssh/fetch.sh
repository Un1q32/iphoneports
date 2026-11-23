#!/bin/sh
. ../../files/dllib.sh
ver='10.6p2'
dlsrc \
    "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-$ver.tar.gz" \
    "openssh-$ver.tar.gz" \
    9ae44872090cf2f06b3cf9ff147e7f16f309671340763ed2f99248398ae29d5b \
    "openssh-$ver"
