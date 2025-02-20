#!/bin/sh -e
(
cd src
./configure --prefix=/var/usr --disable-static CC="$_TARGET-cc"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install -j"$_JOBS"
)

(
cd pkg/var/usr
rm -rf share
for lib in lib/*.dylib; do
    if [ -f "$lib" ] && [ ! -h "$lib" ]; then
        "$_TARGET-strip" "$lib" 2>/dev/null || true
        ldid -S"$_ENT" "$lib"
    fi
done
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "lzlib-$_CPU-$_SUBSYSTEM.deb"
