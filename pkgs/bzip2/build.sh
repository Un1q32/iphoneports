#!/bin/sh
(
cd src || exit 1
"$_MAKE" CC="$_TARGET-cc" DESTDIR="$_PKGROOT/pkg" PREFIX=/var/usr install -j8
)

(
cd pkg/var/usr || exit 1
rm -rf man bin/*grep
"$_TARGET-strip" bin/bzip2 bin/bzip2recover lib/libbz2.1.0.dylib > /dev/null 2>&1
ldid -S"$_ENT" bin/bzip2 bin/bzip2recover lib/libbz2.1.0.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg bzip2.deb
