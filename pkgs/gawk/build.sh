#!/bin/sh -e
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --with-readline
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share/info share/man bin/gawk-* bin/gawkbug
"$_TARGET-strip" bin/gawk lib/gawk/* libexec/awk/* 2>/dev/null || true
ldid -S"$_ENT" bin/gawk lib/gawk/* libexec/awk/*
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
