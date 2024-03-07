#!/bin/sh
(
cd src || exit 1
for src in crc32.cc support.cc guid.cc gptpart.cc mbrpart.cc basicmbr.cc mbr.cc gpt.cc bsd.cc parttypes.cc attributes.cc diskio.cc diskio-unix.cc; do
  "$_TARGET-c++" "$src" -c -O2 &
done
wait
"$_TARGET-c++" -o libgptfdisk.dylib -shared -install_name /var/usr/lib/libgptfdisk.dylib -O2 crc32.o support.o guid.o gptpart.o mbrpart.o basicmbr.o mbr.o gpt.o bsd.o parttypes.o attributes.o diskio.o diskio-unix.o
"$_TARGET-c++" libgptfdisk.dylib gdisk.cc gpttext.cc -o gdisk -O2
"$_TARGET-c++" libgptfdisk.dylib cgdisk.cc gptcurses.cc -o cgdisk -O2 -lncurses
"$_TARGET-c++" libgptfdisk.dylib sgdisk.cc gptcl.cc -o sgdisk -O2 -lpopt
"$_TARGET-c++" libgptfdisk.dylib fixparts.cc -o fixparts -O2
mkdir -p "$_PKGROOT/pkg/var/usr/sbin" "$_PKGROOT/pkg/var/usr/lib"
cp gdisk cgdisk sgdisk fixparts "$_PKGROOT/pkg/var/usr/sbin"
cp libgptfdisk.dylib "$_PKGROOT/pkg/var/usr/lib"
)

(
cd pkg/var/usr || exit 1
llvm-strip sbin/* lib/libgptfdisk.dylib
ldid -S"$_ENT" sbin/* lib/libgptfdisk.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg gptfdisk.deb
