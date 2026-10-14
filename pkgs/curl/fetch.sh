#!/bin/sh
. ../../files/dllib.sh
ver='8.23.0'
dlsrc \
    "https://curl.se/download/curl-$ver.tar.xz" \
    "curl-$ver.tar.xz" \
    8dadd7d2536a314f982ad05a651b713f426bf7d02cc2c76cffb9796f2218e6c5 \
    "curl-$ver"
