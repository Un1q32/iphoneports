#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
"$_TARGET-cc" ping.c -o ping -Os -flto -Wno-deprecated-non-prototype
mkdir -p "$_DESTDIR/var/usr/sbin"
cp ping "$_DESTDIR/var/usr/sbin"
if [ "$_SUBSYSTEM" != "ios" ] || [ "$_TRUEOSVER" -ge 20000 ]; then
    "$_TARGET-cc" ping6.c md5.c -o ping6 -Os -flto -Wno-deprecated-non-prototype -Wno-format -D__APPLE_USE_RFC_2292
    cp ping6 "$_DESTDIR/var/usr/sbin"
fi
)

(
cd "$_DESTDIR/var/usr/sbin"
strip_and_sign ping
chmod 4755 ping
installsuid ping
if [ -f ping6 ]; then
    strip_and_sign ping6
    chmod 4755 ping6
    installsuid ping6
fi
)

installlicense files/*

builddeb
