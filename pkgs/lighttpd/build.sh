#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd "$_SRCDIR"
./autogen.sh
if [ "$_SUBSYSTEM" = "ios" ] && [ "$_OSVER" -lt 20000 ]; then
    posix_spawn='ac_cv_func_posix_spawn=no'
fi
./configure \
    --host="$_TARGET" \
    --enable-silent-rules \
    --prefix=/var/usr \
    --with-openssl \
    --with-zlib \
    --with-bzip2 \
    --with-brotli \
    --with-zstd \
    --with-lua \
    --with-sqlite \
    --with-webdav-props \
    --with-xxhash \
    PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" \
    $posix_spawn
make
make install DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign sbin/lighttpd sbin/lighttpd-angel lib/liblightcomp.dylib lib/*.so
)

installlicense "$_SRCDIR/COPYING"

builddeb
