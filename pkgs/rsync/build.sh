#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --disable-md2man \
    --with-included-zlib=no \
    rsync_cv_HAVE_C99_VSNPRINTF=yes \
    rsync_cv_HAVE_SECURE_MKSTEMP=yes \
    rsync_cv_MKNOD_CREATES_FIFOS=yes \
    rsync_cv_MKNOD_CREATES_SOCKETS=no
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/rsync
)

installlicense "$_SRCDIR/COPYING"

builddeb
