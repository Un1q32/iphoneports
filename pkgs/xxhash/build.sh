#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
"$_MAKE" install UNAME=Darwin CC="$_TARGET-cc" AR="$_TARGET-ar" PREFIX=/var/usr DESTDIR="$_PKGROOT/pkg" -j"$_JOBS"
)

(
cd pkg/var/usr
rm -rf share lib/libxxhash.a
strip_and_sign bin/xxhsum lib/libxxhash.0.*.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
