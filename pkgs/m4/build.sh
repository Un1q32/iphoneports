#!/bin/sh
# shellcheck disable=2086
set -e
. ../../files/lib.sh

(
cd src
autoreconf -f
if [ "$_SUBSYSTEM" = "ios" ] && [ "$_TRUEOSVER" -lt 20000 ]; then
    posix_spawn='ac_cv_func_posix_spawn=no'
fi
./configure --host="$_TARGET" --prefix=/var/usr $posix_spawn
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share
strip_and_sign bin/m4
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
