#!/bin/sh
(
cd source || exit 1
autoreconf -fi
./configure --host="$_TARGET" --prefix=/usr --disable-shared --enable-static
"$_MAKE" -j4
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" -x usr/bin/lua
ldid -S"$_BSROOT/entitlements.xml" usr/bin/lua
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package mono-6.12.0.190.deb
