#!/bin/sh
. ../../files/dllib.sh
ver='1.12.1'
dlsrc \
    "https://github.com/nih-at/libzip/releases/download/v$ver/libzip-$ver.tar.xz" \
    "libzip-$ver.tar.gz" \
    c40062022a1963c80573d48f6070792297cecd7c6bffe3aefcac0d8b9bee8913 \
    "libzip-$ver"
