#!/bin/sh -e
(
cd src || exit 1
./autogen
./configure --host="$_TARGET" --prefix=/var/usr CPPFLAGS='-Wno-incompatible-function-pointer-types'
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share/doc share/man
"$_TARGET-strip" bin/dpkg bin/dpkg-deb bin/dpkg-divert bin/dpkg-query bin/dpkg-realpath bin/dpkg-split bin/dpkg-statoverride bin/dpkg-trigger bin/dselect bin/update-alternatives sbin/start-stop-daemon 2>/dev/null || true
ldid -S"$_ENT" bin/dpkg bin/dpkg-deb bin/dpkg-divert bin/dpkg-query bin/dpkg-realpath bin/dpkg-split bin/dpkg-statoverride bin/dpkg-trigger bin/dselect bin/update-alternatives sbin/start-stop-daemon
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg dpkg.deb
