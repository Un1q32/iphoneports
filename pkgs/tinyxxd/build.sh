#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
"$_TARGET-cc" -std=c11 -O3 -flto -o tinyxxd main.c
mkdir -p "$_PKGROOT"/pkg/var/usr/bin
cp tinyxxd "$_PKGROOT"/pkg/var/usr/bin
)

(
cd pkg/var/usr/bin
strip_and_sign tinyxxd
ln -s tinyxxd xxd
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
