#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
make CC="$_TARGET-cc" RANLIB="$_TARGET-ranlib" PREFIX=/var/usr DESTDIR="$_DESTDIR" BUILD_STATIC=no TARGET_OS=Darwin install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/lz4 lib/liblz4.1.*.dylib
)

installlicense "$_SRCDIR/LICENSE"

builddeb
