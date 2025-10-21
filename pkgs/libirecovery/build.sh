#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --without-udev --without-iokit PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr
strip_and_sign bin/irecovery lib/libirecovery-1.0.5.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
