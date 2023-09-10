#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --disable-static PKG_CONFIG_PATH="$_SDK/var/usr/lib/pkgconfig" ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes
"$_MAKE" -j8
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" sbin/usbmuxd > /dev/null 2>&1
ldid -S"$_ENT" sbin/usbmuxd
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg usbmuxd.deb
