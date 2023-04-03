#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j8
mkdir -p "$_PKGROOT/package/usr/bin"
mkdir -p "$_PKGROOT/package/bin"
"$_CP" src/tar "$_PKGROOT/package/usr/bin"
)

(
cd package || exit 1
ln -s ../usr/bin/tar bin/tar
"$_TARGET-strip" usr/bin/tar > /dev/null 2>&1
ldid -S"$_BSROOT/entitlements.xml" usr/bin/tar
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package tar-1.34.deb
