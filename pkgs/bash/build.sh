#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc --bindir=/bin --with-installed-readline
"$_MAKE" -j4
mkdir -p "$_PKGROOT"/package/bin
cp bash "$_PKGROOT"/package/bin
)

(
cd package || exit 1
ln -s bash bin/sh
"$_TARGET-strip" -x bin/bash
ldid -S"$_BSROOT/entitlements.plist" bin/bash
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package bash-5.2.15.deb
