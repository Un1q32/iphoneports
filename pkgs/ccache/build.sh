#!/bin/sh
mkdir -p src/build
(
cd src/build || exit 1
cmake -GNinja .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr"
DESTDIR="$_PKGROOT/pkg" ninja install -j8
)

(
cd pkg/var/usr || exit 1
"$_TARGET-strip" bin/ccache 2>/dev/null
ldid -S"$_ENT" bin/ccache
mkdir -p share/ccache etc/profile.d
cp "$_PKGROOT/files/ccache.sh" etc/profile.d
for cc in cc c++ gcc g++ clang clang++; do
  ln -s ../../bin/ccache "share/ccache/$cc"
done
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ccache.deb
