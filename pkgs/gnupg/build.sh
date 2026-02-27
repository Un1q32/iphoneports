#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --disable-static \
    --disable-doc \
    --enable-silent-rules \
    --disable-ldap \
    SYSROOT="$_SDK" \
    PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" \
    PKG_CONFIG_SYSROOT_DIR="$_SDK/var/usr/lib/pkgconfig" \
    GPGRT_CONFIG="$_SDK/var/usr/bin/gpgrt-config"
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share/doc
strip_and_sign bin/*
for bin in libexec/*; do
    [ "$bin" != "libexec/gpg-wks-client" ] && strip_and_sign "$bin"
done
)

installlicense "$_SRCDIR/COPYING"

builddeb
