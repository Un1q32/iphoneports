#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc --bindir=/bin --with-installed-readline
"$_MAKE" -j8
mkdir -p "$_PKGROOT/package/usr/bin"
mkdir -p "$_PKGROOT/package/bin"
"$_CP" tcsh "$_PKGROOT"/package/usr/bin
)

(
cd package || exit 1
ln -s ../usr/bin/tcsh bin/tcsh
"$_TARGET-strip" usr/bin/tcsh
ldid -S"$_BSROOT/entitlements.xml" usr/bin/tcsh
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package tcsh-6.24.07.deb
