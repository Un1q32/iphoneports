#!/bin/sh -e
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-cxx --disable-static --disable-doc
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install -j"$_JOBS"
)

(
cd pkg/var/usr
rm -rf share
abi=4
lib="$(realpath lib/libmpdec.$abi.dylib)"
"$_TARGET-install_name_tool" -id /var/usr/lib/libmpdec.$abi.dylib "$lib"
"$_TARGET-strip" "$lib" 2>/dev/null || true
ldid -S"$_ENT" "$lib"
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYRIGHT.txt "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
