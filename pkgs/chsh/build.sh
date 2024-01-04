#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" "$_PKGROOT/files/iphoneports-chsh.c" -o iphoneports-chsh -O2
mkdir -p "$_PKGROOT/pkg/usr/bin"
cp iphoneports-chsh "$_PKGROOT/pkg/usr/bin"
)

(
cd pkg/usr/bin || exit 1
llvm-strip iphoneports-chsh
ldid -S"$_ENT" iphoneports-chsh
chmod 4755 iphoneports-chsh
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg chsh.deb
