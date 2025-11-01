#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd "$_SRCDIR"
if [ "$_SUBSYSTEM" = "ios" ] && [ "$_OSVER" -lt 20000 ]; then
    flags='--disable-ipv6 ac_cv_func_posix_spawn=no'
fi
./configure --host="$_TARGET" --prefix=/var/usr --with-ssl=openssl --disable-iri $flags
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/wget
)

installlicense "$_SRCDIR/COPYING"

builddeb
