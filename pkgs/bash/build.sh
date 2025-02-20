#!/bin/sh -e
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --with-installed-readline CFLAGS="-Wno-parentheses -Wno-format-security -Wno-deprecated-non-prototype -O3"
"$_MAKE" -j"$_JOBS"
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp bash "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr
"$_TARGET-strip" bin/bash 2>/dev/null || true
ldid -S"$_ENT" bin/bash
mkdir -p etc/bash/bashrc.d
)

cp files/bashrc pkg/var/usr/etc/bash

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "bash-$_DPKGARCH.deb"
