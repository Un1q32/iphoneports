#!/bin/sh
(
mkdir -p package/usr/bin
cd source || exit 1
"$_MAKE" CC="$_TARGET-clang" TARGET_DIR_BIN="$_PKGROOT/package/usr/bin" install -j4
)

(
cd package || exit 1
"$_TARGET-strip" -x usr/bin/vi
"$_TARGET-strip" -x usr/bin/ex
ldid -S"$_BSROOT/entitlements.xml" usr/bin/vi
ldid -S"$_BSROOT/entitlements.xml" usr/bin/ex
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package nextvi-1.1.deb
