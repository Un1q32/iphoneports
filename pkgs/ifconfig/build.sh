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
strip_and_sign ifconfig
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
