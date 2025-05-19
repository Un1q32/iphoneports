#!/bin/sh
set -e
. ../../lib.sh
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --enable-scorefile=/var/usr/share/rogue/scores --enable-setgid
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share/doc share/man
strip_and_sign bin/rogue
chmod 2755 bin/rogue
)

mkdir -p pkg/usr/local/libexec/iphoneports
mv pkg/var/usr/bin/rogue pkg/usr/local/libexec/iphoneports
ln -s ../../../../usr/local/libexec/iphoneports/rogue pkg/var/usr/bin/rogue

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE.TXT "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
