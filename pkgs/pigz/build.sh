#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
make CC="$_TARGET-cc"
mkdir -p "$_DESTDIR/var/usr/bin"
cp pigz "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/pigz"
ln -s pigz "$_DESTDIR/var/usr/bin/unpigz"

installlicense files/LICENSE

builddeb
