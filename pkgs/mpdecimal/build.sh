#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-cxx --disable-static --disable-doc
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install -j8
)

(
cd pkg/var/usr || exit 1
rm -rf share
lib="$(realpath lib/libmpdec.dylib)"
"$_TARGET-strip" "$lib" 2>/dev/null
ldid -S"$_ENT" "$lib"
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg mpdecimal.deb
