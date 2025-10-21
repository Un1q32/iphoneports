#!/bin/sh
. ../../files/lib.sh

(
cd src
autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --disable-static --enable-silent-rules
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
strip_and_sign lib/libyaml-0.2.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/License "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
