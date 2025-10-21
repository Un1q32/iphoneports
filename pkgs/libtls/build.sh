#!/bin/sh
set -e
. ../../files/lib.sh

(
cd src
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --enable-libtls-only --disable-static CFLAGS='-O3 -flto'
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf etc
chmod +x lib/libtls.*.dylib lib/libtls.la
strip_and_sign lib/libtls.*.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
