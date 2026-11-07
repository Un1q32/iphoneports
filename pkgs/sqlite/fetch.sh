#!/bin/sh
. ../../files/dllib.sh
ver='3540100'
dlsrc \
    "https://sqlite.org/2026/sqlite-autoconf-$ver.tar.gz" \
    "sqlite-$ver.tar.gz" \
    926ef8d3eab93fbf6e06011901273eec076b25594a4e1cdadd50c987f4f6d64e \
    "sqlite-autoconf-$ver"
