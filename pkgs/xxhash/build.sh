#!/bin/sh
. ../../files/lib.sh

(
cd src
make install UNAME=Darwin CC="$_TARGET-cc" AR="$_TARGET-ar" PREFIX=/var/usr DESTDIR="$_DESTDIR" -j"$_JOBS"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share lib/libxxhash.a
strip_and_sign bin/xxhsum lib/libxxhash.0.*.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
