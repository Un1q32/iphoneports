#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-install-examples --disable-static
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share bin
strip_and_sign lib/libhistory.8.*.dylib lib/libreadline.8.*.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
