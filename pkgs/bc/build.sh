#!/bin/sh
. ../../files/lib.sh

(
cd src
CC="$_TARGET-cc" HOSTCC=cc ./configure --prefix=/var/usr --enable-readline --disable-nls --disable-strip --disable-man-pages
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"/bin
strip_and_sign bc
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE.md "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
