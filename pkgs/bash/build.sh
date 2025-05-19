#!/bin/sh
set -e
. ../../lib.sh
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --with-installed-readline CFLAGS="-Wno-parentheses -Wno-format-security -Wno-deprecated-non-prototype -O3"
"$_MAKE" -j"$_JOBS"
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp bash "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr
strip_and_sign bin/bash
mkdir -p etc/bash/bashrc.d
)

cp files/bashrc pkg/var/usr/etc/bash

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
