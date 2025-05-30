#!/bin/sh
set -e
. ../../lib.sh
(
cd src
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
for src in gzip.c futimens.c; do
    "$_TARGET-cc" -Os -flto -c "$src" -DGZIP_APPLE_VERSION='"448.0.3"' -D'__FBSDID(x)=' &
done
wait
"$_TARGET-cc" -o gzip -Os -flto -llzma -lz -lbz2 ./*.o
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

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
