#!/bin/sh
mkdir -p "$_PKGROOT/pkg/usr/libexec/iphoneports" "$_PKGROOT/pkg/var/usr/bin"
"$_TARGET-cc" -Wall -Wextra -Wpedantic -std=c99 -O2 "$_PKGROOT/files/iphoneports-chsh.c" -o "$_PKGROOT/pkg/usr/libexec/iphoneports/iphoneports-chsh"

llvm-strip "$_PKGROOT/pkg/usr/libexec/iphoneports/iphoneports-chsh"
ldid -S"$_ENT" "$_PKGROOT/pkg/usr/libexec/iphoneports/iphoneports-chsh"
chmod 4755 "$_PKGROOT/pkg/usr/libexec/iphoneports/iphoneports-chsh"

ln -s /usr/libexec/iphoneports/iphoneports-chsh "$_PKGROOT/pkg/var/usr/bin"

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg chsh.deb
