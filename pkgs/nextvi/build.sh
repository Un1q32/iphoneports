#!/bin/sh
(
mkdir -p package/usr/bin
cd source || exit 1
"$_TARGET-clang" -pedantic -std=c99 -D_POSIX_C_SOURCE=200809L -D_DARWIN_C_SOURCE -O2 vi.c -o "$_PKGROOT/package/usr/bin/vi"
)

(
cd package || exit 1
"$_TARGET-strip" -x usr/bin/vi
ldid -S"$_BSROOT/entitlements.xml" usr/bin/vi
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package nextvi-1.0.deb
