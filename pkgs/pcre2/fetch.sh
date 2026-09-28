#!/bin/sh
. ../../files/dllib.sh
ver='10.49'
dlsrc \
    "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$ver/pcre2-$ver.tar.bz2" \
    "pcre2-$ver.tar.bz2" \
    53c156e1ba416a20da8e65395daa132da0d80e76910424caca3fcdae7831d384 \
    "pcre2-$ver"
