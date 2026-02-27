#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
./configure --prefix=/var/usr
make
make install DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share/man share/info
sed -i -e '1s|.*|#!/var/usr/bin/perl|' bin/*
)

installlicense "$_SRCDIR/COPYING"

builddeb
