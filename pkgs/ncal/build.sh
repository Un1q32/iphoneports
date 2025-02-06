#!/bin/sh -e
(
cd src || exit 1
for src in ncal.c calendar.c easter.c; do
  "$_TARGET-cc" -c "$src" -Os -flto -I. -D'__FBSDID(x)=' &
done
wait
"$_TARGET-cc" -o ncal -Os -flto -lncurses ./*.o
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp ncal "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" ncal 2>/dev/null || true
ldid -S"$_ENT" ncal
ln -s ncal cal
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "ncal-$_DPKGARCH.deb"
