#!/bin/sh
. ../../files/dllib.sh
ver='0.26.1'
dlsrc \
    "https://github.com/sharkdp/bat/archive/refs/tags/v$ver.tar.gz" \
    "bat-$ver.tar.gz" \
    4474de87e084953eefc1120cf905a79f72bbbf85091e30cf37c9214eafcaa9c9 \
    "bat-$ver"
