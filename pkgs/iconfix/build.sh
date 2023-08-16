#!/bin/sh
mkdir -p pkg/usr/bin
"$_CP" "$_PKGROOT/src/iconfix.sh" "$_PKGROOT/pkg/usr/bin/iconfix"

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg iconfix.deb
