#!/bin/sh
(
cd source || exit 1
mkdir -p "$_PKGROOT/package/usr/bin" "$_PKGROOT/package/usr/share/cowsay"
"$_CP" cowsay "$_PKGROOT/package/usr/bin"
"$_CP" -a cowthink "$_PKGROOT/package/usr/bin"
"$_CP" -r share/cows "$_PKGROOT/package/usr/share/cowsay"
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package cowsay-3.7.0.deb
