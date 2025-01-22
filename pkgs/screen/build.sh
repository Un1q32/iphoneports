#!/bin/sh -e
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --enable-colors256 --enable-rxvt_osc --enable-telnet CPPFLAGS="-Wno-implicit-function-declaration"
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
mkdir -p "$_PKGROOT/pkg/var/usr/etc"
cp etc/etcscreenrc "$_PKGROOT/pkg/var/usr/etc/screenrc"
)

(
cd pkg/var/usr || exit 1
rm -rf share/info share/man
"$_TARGET-strip" bin/screen-* 2>/dev/null || true
ldid -S"$_ENT" bin/screen-*
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg screen.deb
