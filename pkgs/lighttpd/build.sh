#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd src
./autogen.sh
if [ "$_SUBSYSTEM" = "ios" ] && [ "$_TRUEOSVER" -lt 20000 ]; then
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
make -j"$_JOBS"
make install DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign sbin/lighttpd sbin/lighttpd-angel lib/liblightcomp.dylib lib/*.so
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
