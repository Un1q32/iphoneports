#!/bin/sh
(
cd src || exit 1
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/ideviceinstaller 2>/dev/null
ldid -S"$_ENT" bin/ideviceinstaller
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ideviceinstaller.deb
