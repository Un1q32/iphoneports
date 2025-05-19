#!/bin/sh
set -e
. ../../lib.sh
# shellcheck disable=2086
(
cd src
case ${_TARGET%%-*} in
    arm64*) ;;
    arm*) disableasm='--disable-assembly' ;;
esac
./configure --host="$_TARGET" --prefix=/var/usr --disable-static $disableasm
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr
rm -rf share
strip_and_sign lib/libgmp.10.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
