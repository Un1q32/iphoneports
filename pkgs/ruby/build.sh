#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-destdir="$_PKGROOT/pkg" --disable-install-doc --enable-shared ac_cv_func_backtrace=no ac_cv_func_fgetattrlist=no
"$_MAKE" -j8
"$_MAKE" install
)

(
rm -rf pkg/home
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/ruby lib/libruby.3.3.dylib 2>/dev/null
ldid -S"$_ENT" bin/ruby lib/libruby.3.3.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ruby.deb
