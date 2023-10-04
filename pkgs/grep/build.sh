#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -O2 -o grep grep.c util.c queue.c file.c -include "$_PKGROOT/files/compat.h" -D'__FBSDID(x)=' -lbz2 -llzma -lz
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp grep "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" grep > /dev/null 2>&1
ldid -S"$_ENT" grep
for link in egrep fgrep rgrep bzgrep bzegrep bzfgrep zgrep zegrep zfgrep; do
    ln -s grep "$link"
done
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg grep.deb
