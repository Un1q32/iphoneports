#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd src
autoreconf -f
if [ "$_SUBSYSTEM" = "ios" ] && [ "$_TRUEOSVER" -lt 20000 ]; then
    posix_spawn='ac_cv_func_posix_spawn=no'
fi
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --with-ssl=openssl \
    --with-openssl \
    --with-lzma \
    --with-bzip2 \
    --without-gpgme \
    --disable-static \
    --disable-doc \
    --disable-valgrind-tests \
    CPPFLAGS='-Wno-unknown-attributes' \
    PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" \
    PKG_CONFIG_SYSROOT_DIR="$_SDK" \
    gl_cv_onwards_func_futimens=yes \
    $posix_spawn
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share bin/wget2_noinstall
strip_and_sign bin/wget2 lib/libwget.3.dylib
)

installlicense "$_SRCDIR/COPYING"

builddeb
