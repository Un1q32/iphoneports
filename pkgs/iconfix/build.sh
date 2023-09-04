#!/bin/sh
mkdir -p pkg/usr/bin
cp "$_PKGROOT/src/iconfix.sh" "$_PKGROOT/pkg/usr/bin/iconfix"

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg iconfix.deb
