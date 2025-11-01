#!/bin/sh
. ../../files/lib.sh

(
cd src
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --without-libiberty --without-avahi --disable-Werror --enable-rfc2553 --disable-pump-mode rsync_cv_HAVE_C99_VSNPRINTF=yes
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share sbin
for bin in distcc distccd distccmon-text lsdistcc; do
    strip_and_sign "bin/$bin"
done
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
