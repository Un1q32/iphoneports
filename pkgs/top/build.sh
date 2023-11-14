#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -O2 top.c libtop.c log.c samp.c disp.c ch.c dch.c -o top -DTOP_DEPRECATED -Wno-invalid-pp-token -Wno-implicit-function-declaration -Wno-constant-conversion -Wno-tautological-constant-out-of-range-compare -lncurses -lutil -lpanel -framework IOKit -framework CoreFoundation
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp top "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" top > /dev/null 2>&1
ldid -S"$_ENT" top
chmod 4755 top
)

mkdir -p pkg/usr/libexec/iphoneports
mv pkg/var/usr/bin/top pkg/usr/libexec/iphoneports/top
ln -s ../../../../usr/libexec/iphoneports/top pkg/var/usr/bin/top

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg top.deb
