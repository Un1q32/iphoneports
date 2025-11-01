#!/bin/sh
. ../../files/lib.sh

mkdir -p "$_DESTDIR/var/usr/etc/profile.d"
cp files/sdkroot.sh "$_DESTDIR/var/usr/etc/profile.d"
cp -a "$("$_TARGET-sdkpath")" "$_DESTDIR/var/usr/sdk"

builddeb
