#!/bin/sh -e
(
cd src
./configure --prefix=/var/usr
"$_MAKE" install DESTDIR="$_PKGROOT/pkg" -j"$_JOBS"
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg bash-completion.deb
