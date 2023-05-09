#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc --bindir=/bin --enable-pcre
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
mkdir -p "$_PKGROOT/package/etc"
"$_CP" files/zprofile "$_PKGROOT/package/etc"
cd package || exit 1
rm -rf bin/zsh-5.9 usr/share/man
"$_TARGET-strip" bin/zsh > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/zsh
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package zsh.deb
