#!/bin/sh -e
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-cxx --disable-static --disable-doc
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install -j"$_JOBS"
)

(
cd pkg/var/usr || exit 1
rm -rf share
abi=4
lib="$(realpath lib/libmpdec.$abi.dylib)"
"$_INSTALLNAMETOOL" -id /var/usr/lib/libmpdec.$abi.dylib "$lib"
"$_TARGET-strip" "$lib" 2>/dev/null || true
ldid -S"$_ENT" "$lib"
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "mpdecimal-$_DPKGARCH.deb"
