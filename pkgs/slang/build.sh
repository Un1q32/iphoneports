#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc
"$_MAKE" -j4
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
rm -rf usr/share/doc usr/share/man
"$_TARGET-strip" -x usr/bin/slsh
"$_TARGET-strip" -x usr/lib/libslang.2.3.3.dylib
"$_TARGET-strip" -x usr/lib/slang/v2/modules/*.so
ldid -S"$_BSROOT/entitlements.xml" usr/bin/slsh
ldid -S"$_BSROOT/entitlements.xml" usr/lib/libslang.2.3.3.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/lib/slang/v2/modules/*.so
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package slang-2.3.3.deb
