#!/bin/sh
(
cd src || exit 1
for src in ps.c print.c nlist.c tasks.c keyword.c; do
    "$_TARGET-cc" -O2 -c "$src" -D'__FBSDID(x)=' -Wno-deprecated-non-prototype -Wno-#warnings &
done
wait
"$_TARGET-cc" -o ps -O2 ./*.o
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp ps "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
llvm-strip ps
ldid -S"$_PKGROOT/files/ent.xml" ps
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ps.deb
