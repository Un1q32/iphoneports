#!/bin/sh -e
mkdir -p pkg/var/usr/bin
cp src/pfetch pkg/var/usr/bin

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg pfetch.deb
