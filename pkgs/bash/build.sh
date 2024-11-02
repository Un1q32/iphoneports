#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-installed-readline CFLAGS="-Wno-parentheses -Wno-format-security -Wno-deprecated-non-prototype -O3"
"$_MAKE" -j8
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp bash "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr || exit 1
"$_TARGET-strip" bin/bash 2>/dev/null
ldid -S"$_ENT" bin/bash
mkdir -p etc/bash/bashrc.d
)

cp files/bashrc pkg/var/usr/etc/bash

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg bash.deb
