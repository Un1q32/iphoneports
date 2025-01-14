#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-year2038
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share var
"$_TARGET-strip" bin/find bin/xargs bin/locate libexec/frcode 2>/dev/null
ldid -S"$_ENT" bin/find bin/xargs bin/locate libexec/frcode
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg findutils.deb
