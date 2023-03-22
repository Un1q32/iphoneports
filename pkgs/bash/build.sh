#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc --bindir=/bin --with-installed-readline
"$_MAKE" -j8
mkdir -p "$_PKGROOT"/package/bin
"$_CP" bash "$_PKGROOT"/package/bin
)

(
cd package || exit 1
ln -s bash bin/sh
"$_TARGET-strip" bin/bash > /dev/null 2>1
ldid -S"$_BSROOT/entitlements.xml" bin/bash
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package bash-5.2.15.deb
