#!/bin/sh
. ../../files/lib.sh

(
cd src
"$_MAKE" CC="$_TARGET-cc" DESTDIR="$_PKGROOT/pkg" PREFIX=/var/usr install -j"$_JOBS"
)

(
cd pkg/var/usr
rm -rf man
strip_and_sign bin/bzip2 bin/bzip2recover lib/libbz2.1.0.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
