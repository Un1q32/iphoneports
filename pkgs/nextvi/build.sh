#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -std=c99 -O2 -D_POSIX_C_SOURCE=200809L -D_DARWIN_C_SOURCE vi.c -o vi
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp vi "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
llvm-strip vi
ldid -S"$_ENT" vi
ln -s vi ex
ln -s vi view
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg nextvi.deb
