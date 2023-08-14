#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-installed-readline
"$_MAKE" -j8
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_CP" bash "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr || exit 1
"$_TARGET-strip" bin/bash > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/bash
mkdir -p etc/bash/bashrc.d
)

"$_CP" files/bashrc pkg/var/usr/etc/bash

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg bash.deb
