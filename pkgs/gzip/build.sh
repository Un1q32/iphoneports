#!/bin/sh -e
(
cd src || exit 1
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
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" gzip 2>/dev/null || true
ldid -S"$_ENT" gzip
for link in gunzip gzcat zgrep zegrep zfgrep; do
    ln -s gzip "$link"
done
ln -s zdiff zcmp
ln -s zmore zless
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "gzip-$_DPKGARCH.deb"
