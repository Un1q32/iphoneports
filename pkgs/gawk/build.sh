#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd "$_SRCDIR"
if [ "$_SUBSYSTEM" = "ios" ] && [ "$_OSVER" -lt 20000 ]; then
    flags='ac_cv_func_posix_spawn=no ac_cv_func_posix_spawnp=no'
fi
./configure --host="$_TARGET" --prefix=/var/usr --with-readline $flags
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share/info share/man bin/gawk-* bin/gawkbug
strip_and_sign bin/gawk lib/gawk/* libexec/awk/*
)

installlicense "$_SRCDIR/COPYING"

builddeb
