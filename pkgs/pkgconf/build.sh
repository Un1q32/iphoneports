#!/bin/sh
. ../../files/lib.sh

(
cd src
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/* lib/libpkgconf.*.dylib
ln -s pkgconf bin/pkg-config
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
