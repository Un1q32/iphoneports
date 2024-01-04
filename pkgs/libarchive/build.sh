#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr/bin || exit 1
rm -rf ../share
llvm-strip bsdcat bsdcpio bsdtar bsdunzip ../lib/libarchive.13.dylib
ldid -S"$_ENT" bsdcat bsdcpio bsdtar bsdunzip ../lib/libarchive.13.dylib
for prog in tar cpio unzip; do
    ln -s "bsd$prog" "$prog"
done
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libarchive.deb
