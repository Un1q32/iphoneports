#!/bin/sh

mkdir -p pkg/var/usr/bin
cp src/gdb pkg/var/usr/bin
chmod 755 pkg/var/usr/bin/gdb

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg gdb.deb
