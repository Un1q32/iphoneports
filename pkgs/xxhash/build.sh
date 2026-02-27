#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
make install UNAME=Darwin CC="$_TARGET-cc" AR="$_TARGET-ar" PREFIX=/var/usr DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share lib/libxxhash.a
strip_and_sign bin/xxhsum lib/libxxhash.0.*.dylib
)

installlicense "$_SRCDIR/LICENSE"

builddeb
