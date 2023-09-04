#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr NCURSESW_LIBS="-lncursesw"
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
# for nanorc in files/syntax/*.nanorc; do
#     cp -a "$nanorc" package/usr/share/nano/
# done
cd pkg/var/usr || exit 1
rm -rf share/info share/man share/doc
"$_TARGET-strip" bin/nano > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/nano
)

cp -a files/syntax/*.nanorc pkg/var/usr/share/nano
mkdir -p pkg/var/usr/etc
cp files/nanorc pkg/var/usr/etc

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg nano.deb
