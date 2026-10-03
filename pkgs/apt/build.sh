#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
export PATH="$_SRCDIR/iphoneports-bin:$PATH"
mkdir -p build
cd build
if [ "$_DPKGARCH" = 'all' ]; then
    dpkgarch=iphoneos-arm
else
    dpkgarch="$_DPKGARCH"
fi
cmake -GNinja .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER="$_TARGET-cc" \
    -DCMAKE_CXX_COMPILER="$_TARGET-c++" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_INSTALL_NAME_DIR=/var/usr/lib \
    -DCMAKE_SKIP_RPATH=ON \
    -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr;$_SDK/usr" \
    -DUSE_NLS=OFF \
    -DWITH_DOC=OFF \
    -DWITH_TESTS=OFF \
    -DSTATE_DIR=/var/lib/apt \
    -DCACHE_DIR=/var/cache/apt \
    -DLOG_DIR=/var/log/apt \
    -DCONF_DIR=/var/usr/etc/apt \
    -DROOT_GROUP=wheel \
    -DCURRENT_VENDOR=procursus \
    -DCOMMON_ARCH="$dpkgarch" \
    -DDPKG_DATADIR=/var/usr/share/dpkg \
    -DBERKELEY_INCLUDE_DIRS="$_SDK/var/usr/include" \
    -DBERKELEY_LIBRARIES="$_SDK/var/usr/lib/libdb.dylib"
DESTDIR="$_DESTDIR" ninja install
)

(
cd "$_DESTDIR/var/usr"
for bin in bin/* lib/*.dylib $(find libexec/apt -type f); do
    [ -h "$bin" ] || strip_and_sign "$bin"
done
)

mkdir -p "$_DESTDIR/var/usr/etc/apt/apt.conf.d"
cp "$_PKGROOT/files/00sandbox" "$_DESTDIR/var/usr/etc/apt/apt.conf.d"

installlicense "$_SRCDIR/COPYING"

builddeb
