#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --bindir=/bin
"$_MAKE" -j4
mkdir -p "$_PKGROOT/package/bin"
"$_CP" gzip "$_PKGROOT/package/bin"
"$_CP" gunzip "$_PKGROOT/package/bin"
"$_CP" zcat "$_PKGROOT/package/bin"
"$_CP" zcmp "$_PKGROOT/package/bin"
"$_CP" zdiff "$_PKGROOT/package/bin"
"$_CP" zegrep "$_PKGROOT/package/bin"
"$_CP" zfgrep "$_PKGROOT/package/bin"
"$_CP" zforce "$_PKGROOT/package/bin"
"$_CP" zgrep "$_PKGROOT/package/bin"
"$_CP" zless "$_PKGROOT/package/bin"
"$_CP" zmore "$_PKGROOT/package/bin"
"$_CP" znew "$_PKGROOT/package/bin"
"$_CP" gzexe "$_PKGROOT/package/bin"
)

(
cd package || exit 1
ln -s gunzip bin/uncompress
"$_TARGET-strip" -x bin/gzip
ldid -S"$_BSROOT/entitlements.xml" bin/gzip
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package gzip-1.12.deb
