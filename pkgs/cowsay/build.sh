#!/bin/sh
(
cd source || exit 1
mkdir -p "$_PKGROOT/package/usr/bin"
cp cowsay "$_PKGROOT/package/usr/bin"
cp -a cowthink "$_PKGROOT/package/usr/bin"
cp -r share "$_PKGROOT/package/usr"
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package cowsay-3.7.0.deb
