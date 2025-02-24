#!/bin/sh -e
(
cd src
"$_TARGET-cc" -std=c11 -O3 -flto -o tinyxxd main.c
mkdir -p "$_PKGROOT"/pkg/var/usr/bin
cp tinyxxd "$_PKGROOT"/pkg/var/usr/bin
)

(
cd pkg/var/usr/bin
"$_TARGET-strip" tinyxxd 2>/dev/null || true
ldid -S"$_ENT" tinyxxd
ln -s tinyxxd xxd
)

mkdir -p pkg/var/usr/share/licenses/tinyxxd
cp src/LICENSE pkg/var/usr/share/licenses/tinyxxd

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg tinyxxd.deb
