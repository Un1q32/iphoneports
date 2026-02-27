#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --with-installed-readline \
    CFLAGS="-Wno-parentheses -Wno-format-security -Wno-deprecated-non-prototype -O3" \
    CC_FOR_BUILD='clang' \
    CFLAGS_FOR_BUILD='-std=c99 -O2'
make
mkdir -p "$_DESTDIR/var/usr/bin"
cp bash "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/bash"

mkdir -p "$_DESTDIR/var/usr/etc/bash/bashrc.d"
cp files/bashrc "$_DESTDIR/var/usr/etc/bash"

installlicense "$_SRCDIR/COPYING"

builddeb
