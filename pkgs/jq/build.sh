#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-docs
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share/doc share/man
strip_and_sign bin/jq lib/libjq.*.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
