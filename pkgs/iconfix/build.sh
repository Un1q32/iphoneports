#!/bin/sh
mkdir -p "$_PKGROOT/pkg/usr/bin" "$_PKGROOT/pkg/usr/share/iconfix"
cp "$_PKGROOT/src/iconfix.sh" "$_PKGROOT/pkg/usr/bin/iconfix"
cp "$_PKGROOT"/src/*.png "$_PKGROOT/pkg/usr/share/iconfix"

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg iconfix.deb
