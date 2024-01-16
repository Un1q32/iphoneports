#!/bin/sh
mkdir -p "$_PKGROOT/pkg/usr/bin"
"$_TARGET-cc" -O2 "$_PKGROOT/files/iphoneports-chsh.c" -o "$_PKGROOT/pkg/usr/bin/iphoneports-chsh"

llvm-strip "$_PKGROOT/pkg/usr/bin/iphoneports-chsh"
ldid -S"$_ENT" "$_PKGROOT/pkg/usr/bin/iphoneports-chsh"
chmod 4755 "$_PKGROOT/pkg/usr/bin/iphoneports-chsh"

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg chsh.deb
