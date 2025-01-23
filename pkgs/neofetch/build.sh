#!/bin/sh -e
mkdir -p pkg/var/usr/bin
cp src/neofetch pkg/var/usr/bin

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg neofetch.deb
