#!/bin/sh
. ../../files/lib.sh
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --disable-doc --enable-silent-rules GPGRT_CONFIG="$_SDK/var/usr/bin/gpgrt-config"
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

strip_and_sign pkg/var/usr/lib/libksba.8.dylib

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING.* "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
