#!/bin/sh
. ../../files/dllib.sh
ver='3.14.10'
dlsrc \
    "https://www.python.org/ftp/python/$ver/Python-$ver.tar.xz" \
    "python-$ver.tar.xz" \
    de414a57119abef52784d8993e341d53aed635fc2b05c2607d9f98a2c5b72032 \
    "Python-$ver"
