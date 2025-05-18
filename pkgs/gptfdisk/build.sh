#!/bin/sh -e
(
cd src
[ -d "$_SDK/usr/include/c++" ] && rm "$_SDK/var/usr/lib/libc++.dylib"
for src in crc32.cc support.cc guid.cc gptpart.cc mbrpart.cc basicmbr.cc mbr.cc gpt.cc bsd.cc parttypes.cc attributes.cc diskio.cc diskio-unix.cc; do
    "$_TARGET-c++" "$src" -c -Os -flto &
done
wait
"$_TARGET-c++" -o libgptfdisk.dylib -shared -install_name /var/usr/lib/libgptfdisk.dylib -Os -flto crc32.o support.o guid.o gptpart.o mbrpart.o basicmbr.o mbr.o gpt.o bsd.o parttypes.o attributes.o diskio.o diskio-unix.o
"$_TARGET-c++" libgptfdisk.dylib gdisk.cc gpttext.cc -o gdisk -Os -flto
"$_TARGET-c++" libgptfdisk.dylib cgdisk.cc gptcurses.cc -o cgdisk -Os -flto -lncurses
"$_TARGET-c++" libgptfdisk.dylib sgdisk.cc gptcl.cc -o sgdisk -Os -flto -lpopt
"$_TARGET-c++" libgptfdisk.dylib fixparts.cc -o fixparts -Os -flto
mkdir -p "$_PKGROOT/pkg/var/usr/sbin" "$_PKGROOT/pkg/var/usr/lib"
cp gdisk cgdisk sgdisk fixparts "$_PKGROOT/pkg/var/usr/sbin"
cp libgptfdisk.dylib "$_PKGROOT/pkg/var/usr/lib"
)

(
cd pkg/var/usr
strip_and_sign sbin/* lib/libgptfdisk.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
[ -d "$_SDK/usr/include/c++" ] || sed -i -e '/^Depends:/ s/$/, iphoneports-libc++/' pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
