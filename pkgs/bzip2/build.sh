#!/bin/sh
(
cd src || exit 1
"$_MAKE" CC="$_TARGET-cc" DESTDIR="$_PKGROOT/pkg" PREFIX=/var/usr install -j8
)

(
cd pkg/var/usr || exit 1
rm -rf man
"$_TARGET-strip" bin/bzip2 > /dev/null 2>&1
"$_TARGET-strip" bin/bunzip2 > /dev/null 2>&1
"$_TARGET-strip" bin/bzcat > /dev/null 2>&1
"$_TARGET-strip" bin/bzip2recover > /dev/null 2>&1
"$_TARGET-strip" lib/libbz2.1.0.dylib > /dev/null 2>&1
ldid -S"$_ENT" bin/bzip2
ldid -S"$_ENT" bin/bunzip2
ldid -S"$_ENT" bin/bzcat
ldid -S"$_ENT" bin/bzip2recover
ldid -S"$_ENT" lib/libbz2.1.0.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg bzip2.deb
