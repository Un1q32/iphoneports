#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
for prog in bsdcat bsdcpio bsdtar bsdunzip; do
    "$_TARGET-strip" "bin/$prog" > /dev/null 2>&1
    ldid -S"$_BSROOT/ent.xml" "bin/$prog"
done
"$_TARGET-strip" lib/libarchive.13.dylib > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" lib/libarchive.13.dylib
ln -s bsdtar bin/tar
ln -s bsdcpio bin/cpio
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libarchive.deb
