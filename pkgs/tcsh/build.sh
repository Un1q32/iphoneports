#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure --host="$_TARGET" --prefix=/var/usr
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share
strip_and_sign bin/tcsh
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/Copyright "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
