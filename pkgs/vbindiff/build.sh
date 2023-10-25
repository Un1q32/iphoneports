#!/bin/sh
(
cd src || exit 1
autoreconf -i
./configure --host="$_TARGET" --prefix=/var/usr
"$_TARGET-c++" -O2 -o vbindiff vbindiff.cpp curses/ConWin.cpp GetOpt/GetOpt.cpp -lncurses -lpanel -Icurses
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp vbindiff "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" vbindiff > /dev/null 2>&1
ldid -S"$_ENT" vbindiff
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg vbindiff.deb
