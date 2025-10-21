#!/bin/sh
. ../../files/lib.sh

mkdir -p pkg/var/usr/etc/profile.d
cp "$_PKGROOT/files/sdkroot.sh" pkg/var/usr/etc/profile.d
cp -a "$("$_TARGET-sdkpath")" pkg/var/usr/sdk

builddeb
