#!/bin/sh -e
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --enable-telnet --enable-utmp
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
mkdir -p "$_PKGROOT/pkg/var/usr/etc"
cp etc/etcscreenrc "$_PKGROOT/pkg/var/usr/etc/screenrc"
)

(
cd pkg/var/usr
rm -rf share/info share/man
"$_TARGET-strip" bin/screen-* 2>/dev/null || true
ldid -S"$_ENT" bin/screen-*
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
