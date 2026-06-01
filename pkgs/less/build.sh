#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --host="$_TARGET" --prefix=/var/usr --with-regex=pcre2
make
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/less bin/lesskey libexec/lessecho
)

installlicense "$_SRCDIR/COPYING"

builddeb
