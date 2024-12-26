#!/bin/sh
(
cd src || exit 1
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr --without-libiberty --without-avahi --disable-Werror --enable-rfc2553 --disable-pump-mode
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share sbin
for bin in distcc distccd distccmon-text lsdistcc; do
    "$_TARGET-strip" "bin/$bin" 2>/dev/null
    ldid -S"$_ENT" "bin/$bin"
done
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg distcc.deb
