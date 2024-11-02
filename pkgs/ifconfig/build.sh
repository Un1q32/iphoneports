#!/bin/sh
(
cd src || exit 1
for src in ifconfig.c ifmedia.c; do
  "$_TARGET-cc" -c "$src" -Os -flto -DUSE_IF_MEDIA -DINET6 -DNO_IPX -Wno-deprecated-non-prototype -Wno-extra-tokens &
done
wait
"$_TARGET-cc" -o ifconfig -Os -flto ./*.o
mkdir -p "$_PKGROOT/pkg/var/usr/sbin"
cp ifconfig "$_PKGROOT/pkg/var/usr/sbin"
)

(
cd pkg/var/usr/sbin || exit 1
"$_TARGET-strip" ifconfig 2>/dev/null
ldid -S"$_ENT" ifconfig
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ifconfig.deb
