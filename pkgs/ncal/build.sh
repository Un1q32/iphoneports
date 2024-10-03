#!/bin/sh
(
cd src || exit 1
for src in ncal.c calendar.c easter.c; do
  "$_TARGET-cc" -c "$src" -O2 -I. -D'__FBSDID(x)=' &
done
wait
"$_TARGET-cc" -o ncal -O2 -lncurses ./*.o
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp ncal "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" ncal 2>/dev/null
ldid -S"$_ENT" ncal
ln -s ncal cal
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ncal.deb
