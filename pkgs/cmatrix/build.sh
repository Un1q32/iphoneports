#!/bin/sh
. ../../files/lib.sh

(
cd src
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --without-fonts
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/cmatrix
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
