#!/bin/sh
. ../../files/lib.sh
mkdir -p pkg/var/usr/bin
cp src/neofetch pkg/var/usr/bin

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE.md "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
