#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share/info share/man bin/gawk-* bin/gawkbug
"$_TARGET-strip" bin/gawk > /dev/null 2>&1
"$_TARGET-strip" libexec/awk/* > /dev/null 2>&1
"$_TARGET-strip" lib/gawk/* > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" bin/gawk
ldid -S"$_BSROOT/ent.xml" lib/gawk/*
ldid -S"$_BSROOT/ent.xml" libexec/awk/*
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg gawk.deb
