#!/bin/sh
set -e
. ../../files/lib.sh
mkdir -p pkg/var/usr/bin
cp src/pfetch pkg/var/usr/bin

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
