#!/bin/sh
set -e
. ../../files/lib.sh

(
cd src
mkdir iphoneports-bin
ln -s "$(command -v "$_TARGET-ar")" iphoneports-bin/ar
export PATH="$PWD/iphoneports-bin:$PATH"
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --disable-doc \
    PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" \
    PKG_CONFIG_SYSROOT_DIR="$_SDK/var/usr/lib/pkgconfig" \
    GPGRT_CONFIG="$_SDK/var/usr/bin/gpgrt-config"
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

for bin in pkg/var/usr/bin/*; do
    [ -h "$bin" ] || strip_and_sign "$bin"
done

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
