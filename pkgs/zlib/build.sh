#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
CHOST="$_TARGET" ./configure --prefix=/var/usr --zlib-compat --force-sse2
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share lib/libz.a
for lib in lib/*.dylib; do
    if [ -f "$lib" ] && [ ! -h "$lib" ]; then
        install_name_tool -id /var/usr/lib/libz.1.dylib "$lib"
        strip_and_sign "$lib"
    fi
done
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE.md "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
