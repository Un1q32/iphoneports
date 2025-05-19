#!/bin/sh
set -e
. ../../lib.sh
mkdir -p pkg/var/usr/bin
cp src/neofetch pkg/var/usr/bin

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE.md "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
