#!/bin/sh
. ../../files/dllib.sh
ver='4.14.1'
dlsrc \
    "https://github.com/ccache/ccache/archive/refs/tags/v$ver.tar.gz" \
    "ccache-$ver.tar.gz" \
    cc3da5c9c20c94983fc769ac7c9844f03705cf877d0ce5dedfdc0b39e681e8fd \
    "ccache-$ver"
