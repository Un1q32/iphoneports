#!/bin/sh
set -e
. ../../lib.sh
(
cd src
[ "$_MACVERNUM" -ge 1050 ] && cppflags='CPPFLAGS=-DHAVE_GETHOSTUUID=1'
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-static-shell $cppflags
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr
rm -rf share
mv lib/libsqlite3.*.*.*.dylib lib/libsqlite3.0.dylib
ln -sf libsqlite3.0.dylib lib/libsqlite3.dylib
"$_TARGET-install_name_tool" -id /var/usr/lib/libsqlite3.0.dylib lib/libsqlite3.0.dylib
"$_TARGET-install_name_tool" -change /var/usr/lib/libsqlite3.dylib /var/usr/lib/libsqlite3.0.dylib bin/sqlite3
strip_and_sign bin/sqlite3 lib/libsqlite3.0.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
