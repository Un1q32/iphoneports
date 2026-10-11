#!/bin/sh
. ../../files/dllib.sh
ver='2.7.0'
dlsrc \
    "https://github.com/svaarala/duktape/releases/download/v$ver/duktape-$ver.tar.xz" \
    "duktape-$ver.tar.xz" \
    90f8d2fa8b5567c6899830ddef2c03f3c27960b11aca222fa17aa7ac613c2890 \
    "duktape-$ver"
