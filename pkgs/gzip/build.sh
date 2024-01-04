#!/bin/sh
(
cd src || exit 1
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_TARGET-cc" -O2 -o gzip gzip.c futimens.c -DGZIP_APPLE_VERSION='"400"' -D'__FBSDID(x)=' -llzma -lz -lbz2
for prog in gzip gzexe zdiff zforce zmore znew; do
    cp "$prog" "$_PKGROOT/pkg/var/usr/bin"
    chmod 755 "$_PKGROOT/pkg/var/usr/bin/$prog"
done
)

(
cd pkg/var/usr/bin || exit 1
llvm-strip gzip
ldid -S"$_ENT" gzip
for link in gunzip gzcat zgrep zegrep zfgrep; do
    ln -s gzip "$link"
done
ln -s zdiff zcmp
ln -s zmore zless
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg gzip.deb
