#!/bin/sh -e
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr/bin
rm -rf ../share
"$_TARGET-strip" bsdcat bsdcpio bsdtar bsdunzip ../lib/libarchive.13.dylib 2>/dev/null || true
ldid -S"$_ENT" bsdcat bsdcpio bsdtar bsdunzip ../lib/libarchive.13.dylib
for prog in tar cpio unzip; do
    ln -s "bsd$prog" "$prog"
done
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg libarchive.deb
