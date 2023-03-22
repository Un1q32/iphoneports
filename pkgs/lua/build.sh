#!/bin/sh
(
cd source || exit 1
"$_MAKE" PLAT=macosx INSTALL_TOP=/usr CC="$_TARGET-clang" RANLIB="$_TARGET-ranlib"
"$_MAKE" PLAT=macosx INSTALL_TOP="$_PKGROOT/package/usr" CC="$_TARGET-clang" RANLIB="$_TARGET-ranlib" install
)

(
cd package || exit 1
rm -rf usr/man
"$_TARGET-strip" usr/bin/lua > /dev/null 2>&1
"$_TARGET-strip" usr/bin/luac > /dev/null 2>&1
ldid -S"$_BSROOT/entitlements.xml" usr/bin/lua
ldid -S"$_BSROOT/entitlements.xml" usr/bin/luac
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package lua-5.4.4.deb
