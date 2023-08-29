#!/bin/sh
mkdir -p pkg/var/usr/etc/ssl
"$_CP" src/cert.pem pkg/var/usr/etc/ssl

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ca-certificates.deb
