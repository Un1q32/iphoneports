#!/bin/sh
. ../../files/lib.sh

(
cd src
"$_TARGET-cc" whois.c -o whois -Os -flto -Wno-string-plus-int -D'__FBSDID(x)='
mkdir -p "$_DESTDIR/var/usr/bin"
cp whois "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr"/bin
strip_and_sign whois
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
