#!/bin/sh
. ../../files/dllib.sh
ver='5.9.2'
dlsrc \
    "https://downloads.sourceforge.net/project/zsh/zsh/$ver/zsh-$ver.tar.xz" \
    "zsh-$ver.tar.xz" \
    36fa734374b44783582cec09bcd67822e2f992c779ec1624ab5596df078d2f81 \
    "zsh-$ver"
cp "$_BSROOT/files/gnu-config/"* "$_SRCDIR"
