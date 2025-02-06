#!/bin/sh -e
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-readline
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share/info share/man bin/gawk-* bin/gawkbug
"$_TARGET-strip" bin/gawk lib/gawk/* libexec/awk/* 2>/dev/null || true
ldid -S"$_ENT" bin/gawk lib/gawk/* libexec/awk/*
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "gawk-$_DPKGARCH.deb"
