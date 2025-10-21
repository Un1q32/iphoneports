#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src
"$_MAKE" install CXX="$_TARGET-c++" PREFIX=/var/usr FILESDIR=/var/usr/share/cppcheck DESTDIR="$_PKGROOT/pkg" HAVE_RULES=yes uname_S=Darwin -j"$_JOBS" PCRE_CONFIG="$_SDK/var/usr/bin/pcre-config"
)

(
cd pkg/var/usr/bin
strip_and_sign cppcheck
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
