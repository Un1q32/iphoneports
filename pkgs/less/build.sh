#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-regex=pcre2
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/less bin/lessecho bin/lesskey 2>/dev/null
ldid -S"$_ENT" bin/less bin/lessecho bin/lesskey
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg less.deb
