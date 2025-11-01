#!/bin/sh
. ../../files/lib.sh

(
cd src
"$_TARGET-cc" sw_vers.c -o sw_vers -Os -flto -framework CoreFoundation
mkdir -p "$_DESTDIR/var/usr/bin"
cp sw_vers "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/sw_vers"

installlicense files/LICENSE

builddeb
