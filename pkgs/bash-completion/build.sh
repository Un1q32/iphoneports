#!/bin/sh -e
(
cd src || exit 1
./configure --prefix=/var/usr
"$_MAKE" install DESTDIR="$_PKGROOT/pkg" -j"$_JOBS"
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "bash-completion-$_DPKGARCH.deb"
