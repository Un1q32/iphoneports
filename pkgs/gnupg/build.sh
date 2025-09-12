#!/bin/sh
set -e
. ../../lib.sh

(
cd src
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --disable-static \
    --disable-doc \
    --enable-silent-rules \
    --disable-ldap \
    SYSROOT="$_SDK" \
    PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" \
    PKG_CONFIG_SYSROOT_DIR="$_SDK/var/usr/lib/pkgconfig" \
    GPGRT_CONFIG="$_SDK/var/usr/bin/gpgrt-config"
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share/doc
strip_and_sign bin/*
for bin in libexec/*; do
    [ "$bin" != "libexec/gpg-wks-client" ] && strip_and_sign "$bin"
done
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
