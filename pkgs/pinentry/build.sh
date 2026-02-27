#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
mkdir iphoneports-bin
ln -s "$(command -v "$_TARGET-ar")" iphoneports-bin/ar
export PATH="$PWD/iphoneports-bin:$PATH"
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --disable-doc \
    PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" \
    PKG_CONFIG_SYSROOT_DIR="$_SDK/var/usr/lib/pkgconfig" \
    GPGRT_CONFIG="$_SDK/var/usr/bin/gpgrt-config"
make
make DESTDIR="$_DESTDIR" install
)

for bin in "$_DESTDIR/var/usr/bin"/*; do
    [ -h "$bin" ] || strip_and_sign "$bin"
done

installlicense "$_SRCDIR/COPYING"

builddeb
