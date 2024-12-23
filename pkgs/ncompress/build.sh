#!/bin/sh
(
cd src || exit 1
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_TARGET-cc" -O3 -flto -o compress compress.c -DUTIME_H -DLSTAT -DUSERMEM=800000 -Wno-deprecated-non-prototype
cp compress "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" compress 2>/dev/null
ldid -S"$_ENT" compress
ln -s compress uncompress
ln -s compress zcat
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ncompress.deb
