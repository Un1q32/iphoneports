#!/bin/sh
. ../../files/dllib.sh
ver='6.2.32'
dlsrc \
    "https://download.oracle.com/berkeley-db/db-$ver.tar.gz" \
    "db-$ver.tar.gz" \
    a9c5e2b004a5777aa03510cfe5cd766a4a3b777713406b02809c17c8e0e7a8fb \
    "db-$ver"
cp "$_BSROOT/files/gnu-config/"* "$_SRCDIR/dist"
