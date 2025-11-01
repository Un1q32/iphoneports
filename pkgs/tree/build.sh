#!/bin/sh
. ../../files/lib.sh

(
cd src
make PREFIX="$_DESTDIR/var/usr" CC="$_TARGET-cc" CFLAGS="-Os -flto -std=c99" install -j"$_JOBS"
)

(
cd "$_DESTDIR/var/usr"
rm -rf man
strip_and_sign bin/tree
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
