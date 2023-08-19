#!/bin/sh
(
cd src || exit 1
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_TARGET-cc" -O2 -o compress compress.c -DUTIME_H -DLSTAT -DUSERMEM=800000 -Wno-deprecated-non-prototype
"$_CP" compress "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" compress > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" compress
ln -s compress uncompress
ln -s compress zcat
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ncompress.deb
