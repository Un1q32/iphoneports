#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --enable-colors256 --enable-rxvt_osc --enable-telnet CPPFLAGS="-Wno-implicit-function-declaration"
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
cp etc/etcscreenrc "$_PKGROOT/pkg/var/usr/etc/screenrc"
)

(
cd pkg/var/usr || exit 1
rm -rf share/info share/man
mv bin/screen-* bin/screen
"$_TARGET-strip" bin/screen 2>/dev/null
ldid -S"$_ENT" bin/screen
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg screen.deb
