#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --enable-silent-rules --disable-static --disable-doc gl_cv_posix_shell=/var/usr/bin/sh
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/xz bin/xzdec lib/liblzma.5.dylib
)

installlicense "$_SRCDIR/COPYING"

builddeb
