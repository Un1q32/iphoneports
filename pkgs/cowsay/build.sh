#!/bin/sh
(
cd source || exit 1
mkdir -p "$_PKGROOT/package/usr/bin" "$_PKGROOT/package/usr/share/cowsay"
cp cowsay "$_PKGROOT/package/usr/bin"
cp -a cowthink "$_PKGROOT/package/usr/bin"
cp -r share/cows "$_PKGROOT/package/usr/share/cowsay"
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package cowsay-3.7.0.deb
