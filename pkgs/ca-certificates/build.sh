#!/bin/sh -e
mkdir -p pkg/var/usr/etc/ssl
cp src/cert.pem pkg/var/usr/etc/ssl

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "ca-certificates-$_DPKGARCH.deb"
