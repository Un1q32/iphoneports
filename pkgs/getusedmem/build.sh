#!/bin/sh
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_TARGET-cc" -O2 "$_PKGROOT/files/getusedmem.c" -o "$_PKGROOT/pkg/var/usr/bin/getusedmem"

llvm-strip "$_PKGROOT/pkg/var/usr/bin/getusedmem"
ldid -S"$_ENT" "$_PKGROOT/pkg/var/usr/bin/getusedmem"

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg getusedmem.deb
