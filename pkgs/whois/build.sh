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

installlicense files/LICENSE

builddeb
