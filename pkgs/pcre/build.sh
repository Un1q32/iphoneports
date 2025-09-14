#!/bin/sh
# shellcheck disable=2086
set -e
. ../../lib.sh

(
[ "$_SUBSYSTEM" = "macos" ] && jit=--enable-jit
cd src
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --enable-utf \
    --disable-static \
    --enable-pcretest-libreadline \
    --enable-pcregrep-libbz2 \
    --enable-pcregrep-libz \
    --disable-cpp \
    $jit
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share
strip_and_sign bin/pcretest bin/pcregrep lib/libpcre.1.dylib lib/libpcreposix.0.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENCE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
