#!/bin/sh
(
cd src || exit 1
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr --enable-silent-rules --disable-static gl_cv_posix_shell=/var/usr/bin/sh
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
llvm-strip bin/xz bin/xzdec lib/liblzma.5.dylib
ldid -S"$_ENT" bin/xz bin/xzdec lib/liblzma.5.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg xz.deb
