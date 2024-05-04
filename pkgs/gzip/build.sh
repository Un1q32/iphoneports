#!/bin/sh
(
cd src || exit 1
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
for src in gzip.c futimens.c; do
    "$_TARGET-cc" -O2 -c "$src" -DGZIP_APPLE_VERSION='"400"' -D'__FBSDID(x)=' &
done
wait
"$_TARGET-cc" -o gzip -O2 -llzma -lz -lbz2 ./*.o
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
