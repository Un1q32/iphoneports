#!/bin/sh
. ../../files/lib.sh

(
cd src
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr
make -j"$_JOBS"
make install DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/dash
ln -s dash bin/sh
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
