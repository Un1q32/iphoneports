#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd src
if [ "$_SUBSYSTEM" = "ios" ] && [ "$_TRUEOSVER" -lt 20000 ]; then
    ipv6='--disable-ipv6'
else
    ipv6='--enable-ipv6'
fi
./configure --host="$_TARGET" --prefix=/var/usr --with-ssl --with-brotli --with-zlib $ipv6
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

rm -rf pkg/var/usr/share
strip_and_sign pkg/var/usr/bin/lynx

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
