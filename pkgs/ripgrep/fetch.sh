#!/bin/sh
. ../../files/dllib.sh
ver='16.0.0'
dlsrc \
    "https://github.com/BurntSushi/ripgrep/archive/refs/tags/$ver.tar.gz" \
    "ripgrep-$ver.tar.gz" \
    17e7a1a0db80ed9618a0963c7ae4aecb8fce25c70cf7ebed514daf2b38a0d153 \
    "ripgrep-$ver"
