#!/bin/sh
rm -f "$_TMP/sdk/usr/lib/libz."*
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc --disable-md2man --disable-xxhash
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" usr/bin/rsync > /dev/null 2>&1
ldid -S"$_BSROOT/entitlements.xml" usr/bin/rsync
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package rsync-3.2.7.deb
