#!/bin/sh -e
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
"$_TARGET-strip" lib/libgmp.10.dylib 2>/dev/null || true
ldid -S"$_ENT" lib/libgmp.10.dylib
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg gmp.deb
