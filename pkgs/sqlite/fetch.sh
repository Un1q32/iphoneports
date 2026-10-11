#!/bin/sh
. ../../files/dllib.sh
ver='3540000'
dlsrc \
    "https://sqlite.org/2026/sqlite-autoconf-$ver.tar.gz" \
    "sqlite-$ver.tar.gz" \
    134ec0802dda5795816e25d25872d20b312cb3973438c49b30bc40b7705ea9ed \
    "sqlite-autoconf-$ver"
