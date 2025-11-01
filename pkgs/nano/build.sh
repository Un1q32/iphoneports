#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" gl_cv_func_strcasecmp_works=yes
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share/info share/man share/doc
strip_and_sign bin/nano
)

mkdir -p "$_DESTDIR/var/usr/etc"
cp "$_SRCDIR/doc/sample.nanorc" "$_DESTDIR/var/usr/etc/nanorc"
sed -i 's|# include "/var/usr/share/nano/\*\.nanorc"|include "/var/usr/share/nano/*.nanorc"|' "$_DESTDIR/var/usr/etc/nanorc"

installlicense "$_SRCDIR/COPYING"

builddeb
