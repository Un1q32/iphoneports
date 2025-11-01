#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --with-regex=pcre2
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/less bin/lessecho bin/lesskey
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
