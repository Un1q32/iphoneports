#!/bin/sh
. ../../files/dllib.sh
ver='3.8.2'
dlsrc \
    "https://github.com/libffi/libffi/releases/download/v$ver/libffi-$ver.tar.gz" \
    "libffi-$ver.tar.gz" \
    a699fda2b090c4b46cb79cf60c4dacfce480eb05742c0de66acf3af174a47f92 \
    "libffi-$ver"
