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
llvm-strip bin/gawk lib/gawk/* libexec/awk/*
ldid -S"$_ENT" bin/gawk lib/gawk/* libexec/awk/*
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg gawk.deb
