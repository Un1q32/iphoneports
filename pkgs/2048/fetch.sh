#!/bin/sh
. ../../files/dllib.sh
ver='1.0.4'
dlsrc \
    "https://github.com/mevdschee/2048.c/archive/refs/tags/v$ver.tar.gz" \
    "2048-$ver.tar.gz" \
    76db9965bea484a9c076bdc95109860e15cd3f143e2d5a024fd568e24b795eee \
    "2048.c-$ver"
