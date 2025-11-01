#!/bin/sh
. ../../files/lib.sh

(
cd src
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
make -j"$_JOBS"
make install DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign sbin/usbmuxd
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING.GPLv3 "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
