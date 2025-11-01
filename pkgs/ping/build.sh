#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
"$_TARGET-cc" ping.c -o ping -Os -flto -Wno-deprecated-non-prototype
"$_TARGET-cc" ping6.c md5.c -o ping6 -Os -flto -Wno-deprecated-non-prototype -Wno-format -D__APPLE_USE_RFC_2292
mkdir -p "$_DESTDIR/var/usr/sbin"
cp ping ping6 "$_DESTDIR/var/usr/sbin"
)

(
cd "$_DESTDIR/var/usr"/sbin
strip_and_sign ping ping6
)

installlicense files/*

builddeb
