#!/bin/sh
. ../../files/dllib.sh
ver='3.14.8'
dlsrc \
    "https://www.python.org/ftp/python/$ver/Python-$ver.tar.xz" \
    "python-$ver.tar.xz" \
    c2215904f02b175596dc49351585104f4bc20341e1c47378b26a2c274360ce73 \
    "Python-$ver"
