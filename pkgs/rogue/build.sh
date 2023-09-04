#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --enable-scorefile=/var/usr/share/rogue/scores --enable-setgid
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share/doc share/man
"$_TARGET-strip" bin/rogue > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/rogue
chmod 2755 bin/rogue
)

mkdir -p pkg/usr/libexec/iphoneports
mv pkg/var/usr/bin/rogue pkg/usr/libexec/iphoneports
ln -s ../../../../usr/libexec/iphoneports/rogue pkg/var/usr/bin/rogue

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg rogue.deb
