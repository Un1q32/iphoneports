#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
for nanorc in files/syntax/*.nanorc; do
    "$_CP" -a "$nanorc" package/usr/share/nano/
done
mkdir package/etc
"$_CP" files/nanorc package/etc
cd package || exit 1
rm -rf usr/share/info usr/share/man usr/share/doc
"$_TARGET-strip" usr/bin/nano > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" usr/bin/nano
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package nano.deb
