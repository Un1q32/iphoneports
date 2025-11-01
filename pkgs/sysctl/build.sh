#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
"$_TARGET-cc" sysctl.c -o sysctl -Os -flto -D'__FBSDID(x)=' -w
mkdir -p "$_DESTDIR/var/usr/bin"
cp sysctl "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/sysctl"

installlicense files/LICENSE-*

builddeb
