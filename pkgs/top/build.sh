#!/bin/sh -e
(
cd src
"$_TARGET-cc" -Os -flto top.c libtop.c log.c samp.c disp.c ch.c dch.c -o top -DTOP_DEPRECATED -Wno-invalid-pp-token -Wno-implicit-function-declaration -Wno-constant-conversion -Wno-tautological-constant-out-of-range-compare -lncurses -lutil -lpanel -framework IOKit -framework CoreFoundation
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp top "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
"$_TARGET-strip" top 2>/dev/null || true
ldid -S"$_ENT" top
chmod 4755 top
)

mkdir -p pkg/usr/libexec/iphoneports
mv pkg/var/usr/bin/top pkg/usr/libexec/iphoneports/top
ln -s ../../../../usr/libexec/iphoneports/top pkg/var/usr/bin/top

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg top.deb
