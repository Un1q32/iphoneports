#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --disable-static \
    PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" \
    PKG_CONFIG_SYSROOT_DIR="$_SDK"
make install DESTDIR="$_DESTDIR" -j"$_JOBS"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
for lib in lib/*.dylib; do
    [ -h "$lib" ] || strip_and_sign "$lib"
done
)

installlicense "$_SRCDIR/COPYING"

builddeb
