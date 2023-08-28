#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -O2 top.c libtop.c log.c samp.c disp.c ch.c dch.c -o top -DTOP_DEPRECATED -Wno-invalid-pp-token -Wno-implicit-function-declaration -Wno-constant-conversion -Wno-tautological-constant-out-of-range-compare -lncursesw -lutil -lpanel -framework IOKit -framework CoreFoundation
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_CP" top "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" top > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" top
chmod 4755 top
)

mkdir -p pkg/usr/bin/iphoneports
mv pkg/var/usr/bin/top pkg/usr/bin/iphoneports/top
ln -s ../../../../usr/bin/iphoneports/top pkg/var/usr/bin/top

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg top.deb
