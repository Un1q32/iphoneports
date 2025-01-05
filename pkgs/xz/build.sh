#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --enable-silent-rules --disable-static --disable-doc gl_cv_posix_shell=/var/usr/bin/sh
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/xz bin/xzdec lib/liblzma.5.dylib 2>/dev/null
ldid -S"$_ENT" bin/xz bin/xzdec lib/liblzma.5.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg xz.deb
