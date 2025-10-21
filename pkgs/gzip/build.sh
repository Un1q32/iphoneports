#!/bin/sh
. ../../files/lib.sh
(
cd src
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_TARGET-cc" -Os -flto -o gzip gzip.c -lz -lbz2 -llzma -DGZIP_APPLE_VERSION='"448.0.3"' -D'__FBSDID(x)='
for prog in gzip gzexe zdiff zforce zmore znew; do
    cp "$prog" "$_PKGROOT/pkg/var/usr/bin"
    chmod 755 "$_PKGROOT/pkg/var/usr/bin/$prog"
done
)

(
cd pkg/var/usr/bin
strip_and_sign gzip
for link in gunzip gzcat zgrep zegrep zfgrep; do
    ln -s gzip "$link"
done
ln -s zdiff zcmp
ln -s zmore zless
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
