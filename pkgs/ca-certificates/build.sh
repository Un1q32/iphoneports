#!/bin/sh
mkdir -p pkg/var/usr/etc/ssl
cp src/cert.pem pkg/var/usr/etc/ssl

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ca-certificates.deb
