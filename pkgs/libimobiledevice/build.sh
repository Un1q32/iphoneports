#!/bin/sh -e
(
cd src
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --without-cython --disable-static PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr
rm -rf share
"$_TARGET-strip" lib/libimobiledevice-1.0.6.dylib bin/* 2>/dev/null || true
ldid -S"$_ENT" lib/libimobiledevice-1.0.6.dylib bin/*
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
case $_DPKGARCH in
    iphoneos-*) ;;
    *) sed -i -e 's|iphoneports-usbmuxd, ||' pkg/DEBIAN/control ;;
esac
dpkg-deb -b --root-owner-group -Zgzip pkg "libimobiledevice-$_CPU-$_SUBSYSTEM.deb"
