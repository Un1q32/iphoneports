#!/bin/sh
. ../../files/lib.sh

(
cd src
for src in crc32.cc support.cc guid.cc gptpart.cc mbrpart.cc basicmbr.cc mbr.cc gpt.cc bsd.cc parttypes.cc attributes.cc diskio.cc diskio-unix.cc; do
    "$_TARGET-c++" "$src" -c -Os -flto &
done
wait
"$_TARGET-c++" \
    -o libgptfdisk.dylib \
    -shared \
    -install_name /var/usr/lib/libgptfdisk.dylib \
    -Os -flto \
    ./*.o
"$_TARGET-c++" libgptfdisk.dylib gdisk.cc gpttext.cc -o gdisk -Os -flto
"$_TARGET-c++" libgptfdisk.dylib cgdisk.cc gptcurses.cc -o cgdisk -Os -flto -lncurses
"$_TARGET-c++" libgptfdisk.dylib sgdisk.cc gptcl.cc -o sgdisk -Os -flto -lpopt
"$_TARGET-c++" libgptfdisk.dylib fixparts.cc -o fixparts -Os -flto
mkdir -p "$_DESTDIR/var/usr/sbin" "$_DESTDIR/var/usr/lib"
cp gdisk cgdisk sgdisk fixparts "$_DESTDIR/var/usr/sbin"
cp libgptfdisk.dylib "$_DESTDIR/var/usr/lib"
)

(
cd "$_DESTDIR/var/usr"
strip_and_sign sbin/* lib/libgptfdisk.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
