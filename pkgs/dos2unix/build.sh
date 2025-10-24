#!/bin/sh
. ../../files/lib.sh

(
cd src
make CC="$_TARGET-cc" STRIP=true CPP="$_TARGET-cc -E" DESTDIR="$_PKGROOT/pkg" prefix=/var/usr ENABLE_NLS= install -j"$_JOBS"
)

(
cd pkg/var/usr
rm -rf share
strip_and_sign bin/dos2unix bin/unix2dos
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING.txt "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
