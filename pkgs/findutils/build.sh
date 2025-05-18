#!/bin/sh -e
(
cd src
case $_CPU in
    *64) ;;
    *) y2038='--disable-year2038' ;;
esac
./configure --host="$_TARGET" --prefix=/var/usr $y2038
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share var
strip_and_sign bin/find bin/xargs bin/locate libexec/frcode
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
