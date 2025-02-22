#!/bin/sh -e
(
cd src
for src in ifconfig.c ifmedia.c; do
  "$_TARGET-cc" -c "$src" -Os -flto -DUSE_IF_MEDIA -DINET6 -DNO_IPX -Wno-deprecated-non-prototype -Wno-extra-tokens &
done
wait
"$_TARGET-cc" -o ifconfig -Os -flto ./*.o
mkdir -p "$_PKGROOT/pkg/var/usr/sbin"
cp ifconfig "$_PKGROOT/pkg/var/usr/sbin"
)

(
cd pkg/var/usr/sbin
"$_TARGET-strip" ifconfig 2>/dev/null || true
ldid -S"$_ENT" ifconfig
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg ifconfig.deb
