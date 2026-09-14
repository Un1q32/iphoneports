#!/bin/sh
. ../../files/dllib.sh
ver='593d29141bf176d24021208c75af54a2ef23c38b'
dlsrc \
    "https://github.com/tpoechtrager/apple-libtapi/archive/$ver.tar.gz" \
    "libtapi-$ver.tar.gz" \
    dbad2a41f2351b052367db1fe251bebe43ee9ca5815e46b725c4bc71c339186f \
    "apple-libtapi-$ver"
