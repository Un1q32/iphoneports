#!/bin/sh
(
cd source || exit 1
"$_MAKE" CC="$_TARGET-clang" INSTALLNAMETOOL="$_TARGET-install_name_tool" DESTDIR="$_PKGROOT/package" PREFIX=/usr BINDIR=/bin LIBDIR=/usr/local/lib install -j8
)

(
cd package || exit 1
rm -rf usr/man
"$_TARGET-strip" bin/bzip2 > /dev/null 2>&1
"$_TARGET-strip" bin/bunzip2 > /dev/null 2>&1
"$_TARGET-strip" bin/bzcat > /dev/null 2>&1
"$_TARGET-strip" bin/bzip2recover > /dev/null 2>&1
ldid -S"$_BSROOT/entitlements.xml" bin/bzip2
ldid -S"$_BSROOT/entitlements.xml" bin/bunzip2
ldid -S"$_BSROOT/entitlements.xml" bin/bzcat
ldid -S"$_BSROOT/entitlements.xml" bin/bzip2recover
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package bzip2-1.0.8.deb
