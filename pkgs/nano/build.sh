#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure --host="$_TARGET" --prefix=/var/usr PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" gl_cv_func_strcasecmp_works=yes
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share/info share/man share/doc
strip_and_sign bin/nano
)

mkdir -p pkg/var/usr/etc
cp src/doc/sample.nanorc pkg/var/usr/etc/nanorc
sed -i 's|# include "/var/usr/share/nano/\*\.nanorc"|include "/var/usr/share/nano/*.nanorc"|' pkg/var/usr/etc/nanorc

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
