#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr
"$_MAKE" -j8
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
for prog in gzip gunzip zcat zcmp zdiff zegrep zfgrep zforce zgrep zless zmore znew gzexe; do
    "$_CP" "$prog" "$_PKGROOT/pkg/var/usr/bin"
done
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" gzip > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" gzip
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg gzip.deb
