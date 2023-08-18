#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --with-lzo2
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr/bin || exit 1
rm -rf ../share
for prog in bsdcat bsdcpio bsdtar bsdunzip ../lib/libarchive.13.dylib; do
    "$_TARGET-strip" "$prog" > /dev/null 2>&1
    ldid -S"$_BSROOT/ent.xml" "$prog"
done
ln -s bsdtar tar
ln -s bsdcpio cpio
ln -s bsdunzip unzip
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg libarchive.deb
