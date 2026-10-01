#!/bin/sh
. ../../files/dllib.sh
ver='2.56.0'
dlsrc \
    "https://mirrors.edge.kernel.org/pub/software/scm/git/git-$ver.tar.xz" \
    "git-$ver.tar.xz" \
    26c56c296b38c0695b26fa95f475f1d01704d2d38e73465ca30b0b2f5dc789d3 \
    "git-$ver"
