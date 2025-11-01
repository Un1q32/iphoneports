#!/bin/sh
. ../../files/lib.sh

(
cd src
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes
make -j"$_JOBS"
make install DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/ideviceinstaller
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
