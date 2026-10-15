#!/bin/sh
. ../../files/dllib.sh
ver='1.5.0'
dlsrc \
    "https://github.com/redis/hiredis/archive/refs/tags/v$ver.tar.gz" \
    "hiredis-$ver.tar.gz" \
    eec7ef8641d221e144a58d5ef8d733c8c75c7fd487097a233aacb4fa33981cfb \
    "hiredis-$ver"
