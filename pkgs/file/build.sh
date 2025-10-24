#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd src
./configure --prefix="$_PKGROOT/src/native"
make -j"$_JOBS"
make install
make clean
export PATH="$_PKGROOT/src/native/bin:$PATH"

if [ "$_SUBSYSTEM" = "ios" ] && [ "$_TRUEOSVER" -lt 20000 ]; then
    posix_spawn='ac_cv_func_posix_spawnp=no'
fi
./configure --host="$_TARGET" --prefix=/var/usr --enable-xzlib --enable-bzlib --enable-zlib --enable-zstdlib $posix_spawn
make -j"$_JOBS"
make DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share/man
strip_and_sign bin/file lib/libmagic.1.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
