#!/bin/sh
(
cd src || exit 1
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr --disable-examples --disable-gconf-peer --disable-gtk-peer --disable-plugin
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr/lib/classpath || exit 1
for lib in lib*.dylib; do
  if ! [ -h "$lib" ]; then
    "$_TARGET-strip" "$lib" 2>/dev/null
    ldid -S"$_ENT" "$lib"
  fi
done
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg classpath.deb
