#!/bin/sh
. ../../files/dllib.sh
ver='3.4.3'
dlsrc \
    "https://download.samba.org/pub/rsync/src/rsync-$ver.tar.gz" \
    "rsync-$ver.tar.gz" \
    c72e63ca3021cbc80ba86ec30102773f4c5631fbc492b52e773b3958f82a53d3 \
    "rsync-$ver"
