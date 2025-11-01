#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-seccomp AR="$_TARGET-ar" CPPFLAGS='-Wno-incompatible-function-pointer-types'
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

strip_and_sign pkg/var/usr/bin/*

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
