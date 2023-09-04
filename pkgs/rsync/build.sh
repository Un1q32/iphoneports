#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-md2man --disable-xxhash --with-included-zlib=no
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/rsync > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/rsync
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg rsync.deb
