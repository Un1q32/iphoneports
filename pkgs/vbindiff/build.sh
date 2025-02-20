#!/bin/sh -e
(
cd src
autoreconf -fi
[ -d "$_SDK/usr/include/c++/4.2.1" ] && rm "$_SDK/var/usr/lib/libc++.dylib"
./configure --host="$_TARGET" --prefix=/var/usr
"$_TARGET-c++" -O3 -flto -o vbindiff vbindiff.cpp curses/ConWin.cpp GetOpt/GetOpt.cpp -lncurses -lpanel -Icurses
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp vbindiff "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
"$_TARGET-strip" vbindiff 2>/dev/null || true
ldid -S"$_ENT" vbindiff
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
[ -d "$_SDK/usr/include/c++/4.2.1" ] || sed -i -e '/^Depends:/ s/$/, iphoneports-libc++/' pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "vbindiff-$_CPU-$_SUBSYSTEM.deb"
