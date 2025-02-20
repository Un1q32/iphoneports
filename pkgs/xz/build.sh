#!/bin/sh -e
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --enable-silent-rules --disable-static --disable-doc gl_cv_posix_shell=/var/usr/bin/sh
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share
"$_TARGET-strip" bin/xz bin/xzdec lib/liblzma.5.dylib 2>/dev/null || true
ldid -S"$_ENT" bin/xz bin/xzdec lib/liblzma.5.dylib
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "xz-$_DPKGARCH.deb"
