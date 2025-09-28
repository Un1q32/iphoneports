#!/bin/sh
set -e
. ../../files/lib.sh
mkdir -p src/build
(
cd src/build
cmake -GNinja .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_COMPILER="$_TARGET-cc" \
  -DCMAKE_SYSTEM_NAME=Darwin \
  -DCMAKE_INSTALL_PREFIX=/var/usr \
  -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
  -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
  -DENABLE_DOCUMENTATION=OFF
DESTDIR="$_PKGROOT/pkg" ninja -j"$_JOBS" install
)

(
cd pkg/var/usr
strip_and_sign bin/ccache
mkdir -p share/ccache etc/profile.d
cp "$_PKGROOT/files/ccache.sh" etc/profile.d
for cc in cc c++ gcc g++ clang clang++; do
  ln -s ../../bin/ccache "share/ccache/$cc"
done
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/GPL-3.0.txt "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
