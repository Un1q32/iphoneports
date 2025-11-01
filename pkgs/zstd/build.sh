#!/bin/sh
. ../../files/lib.sh

(
cd src
mkdir tmpbin
ln -s "$(command -v md5sum)" tmpbin/md5
export PATH="$PATH:$PWD/tmpbin"
make CC="$_TARGET-cc" RANLIB="$_TARGET-ranlib" PREFIX=/var/usr UNAME=Darwin -j"$_JOBS"
make DESTDIR="$_DESTDIR" PREFIX=/var/usr UNAME=Darwin install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share lib/libzstd.a
strip_and_sign bin/zstd lib/libzstd.1.*.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
