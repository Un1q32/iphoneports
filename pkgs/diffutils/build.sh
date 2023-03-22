#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j8
mkdir -p "$_PKGROOT/package/usr/bin"
"$_CP" src/diff "$_PKGROOT/package/usr/bin"
"$_CP" src/diff3 "$_PKGROOT/package/usr/bin"
"$_CP" src/sdiff "$_PKGROOT/package/usr/bin"
"$_CP" src/cmp "$_PKGROOT/package/usr/bin"
)

(
cd package || exit 1
"$_TARGET-strip" usr/bin/diff > /dev/null 2>&1
"$_TARGET-strip" usr/bin/diff3 > /dev/null 2>&1
"$_TARGET-strip" usr/bin/sdiff > /dev/null 2>&1
"$_TARGET-strip" usr/bin/cmp > /dev/null 2>&1
ldid -S"$_BSROOT/entitlements.xml" usr/bin/diff
ldid -S"$_BSROOT/entitlements.xml" usr/bin/diff3
ldid -S"$_BSROOT/entitlements.xml" usr/bin/sdiff
ldid -S"$_BSROOT/entitlements.xml" usr/bin/cmp
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package diffutils-3.9.deb
