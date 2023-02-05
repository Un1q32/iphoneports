#!/bin/sh
(
mkdir -p package/usr/bin
cd source || exit 1
"$_MAKE" CC="$_TARGET-clang" OS=Darwin -j4
"$_CP" vi "$_PKGROOT/package/usr/bin"
)

(
cd package || exit 1
ln -s vi usr/bin/ex
"$_TARGET-strip" -x usr/bin/vi
ldid -S"$_BSROOT/entitlements.xml" usr/bin/vi
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package nextvi-1.1.deb
