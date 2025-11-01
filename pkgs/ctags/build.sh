#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --disable-seccomp AR="$_TARGET-ar" CPPFLAGS='-Wno-incompatible-function-pointer-types'
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

strip_and_sign pkg/var/usr/bin/*

installlicense "$_SRCDIR/COPYING"

builddeb
