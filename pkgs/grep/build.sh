#!/bin/sh -e
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/grep 2>/dev/null || true
ldid -S"$_ENT" bin/grep
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg grep.deb
