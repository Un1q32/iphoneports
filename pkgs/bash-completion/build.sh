#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg bash-completion.deb
