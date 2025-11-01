#!/bin/sh
. ../../files/lib.sh

(
cd src
make CC="$_TARGET-cc" DESTDIR="$_DESTDIR" PREFIX=/var/usr install -j"$_JOBS"
)

(
cd "$_DESTDIR/var/usr"
rm -rf man
strip_and_sign bin/bzip2 bin/bzip2recover lib/libbz2.1.0.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
