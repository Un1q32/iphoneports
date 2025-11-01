#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --with-readline
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
