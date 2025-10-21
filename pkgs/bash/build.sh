#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --with-installed-readline \
    CFLAGS="-Wno-parentheses -Wno-format-security -Wno-deprecated-non-prototype -O3" \
    CC_FOR_BUILD='clang' \
    CFLAGS_FOR_BUILD='-std=c99 -O2'
"$_MAKE" -j"$_JOBS"
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp bash "$_PKGROOT/pkg/var/usr/bin"
)

strip_and_sign pkg/var/usr/bin/bash
mkdir -p pkg/var/usr/etc/bash/bashrc.d
cp files/bashrc pkg/var/usr/etc/bash

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
