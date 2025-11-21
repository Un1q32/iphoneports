#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
autoconf
./configure --prefix=/var/usr
make -j"$_JOBS"
make install DESTDIR="$_DESTDIR"
)

(
cd "$_DESTDIR/var/usr/share"
rm -rf man info doc
cd ../bin
ver=$(echo automake-*)
ver="${ver#automake-}"
ln -sf "automake-$ver" automake
ln -sf "aclocal-$ver" aclocal
sed -i -e '1s|.*|#!/var/usr/bin/perl|' "automake-$ver" "aclocal-$ver"
)

installlicense "$_SRCDIR/COPYING"

builddeb
