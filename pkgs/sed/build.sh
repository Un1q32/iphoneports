#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j4
mkdir -p ../package/usr/bin
mkdir -p ../package/bin
cp sed/sed ../package/usr/bin/sed
)

(
cd package || exit 1
ln -s ../usr/bin/sed bin/sed
"$_TARGET-strip" -x usr/bin/sed
ldid -S"$_BSROOT/entitlements.plist" usr/bin/sed
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package sed-4.9.deb
