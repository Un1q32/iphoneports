#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd "$_SRCDIR"
autoreconf -fi
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --without-appletls \
    PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" \
    LIBS='-framework Security' \
    CPPFLAGS='-Wno-deprecated-literal-operator'
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/aria2c
)

installlicense "$_SRCDIR/COPYING"

builddeb
