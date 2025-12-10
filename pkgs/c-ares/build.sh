#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd "$_SRCDIR"
autoreconf -fi
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --disable-static \
    PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign lib/libcares.*.dylib
)

installlicense "$_SRCDIR/LICENSE.md"

builddeb
