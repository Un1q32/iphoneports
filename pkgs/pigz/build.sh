#!/bin/sh
. ../../files/lib.sh

(
cd src
make CC="$_TARGET-cc"
mkdir -p "$_DESTDIR/var/usr/bin"
cp pigz "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr/bin"
ln -s pigz unpigz
strip_and_sign pigz
)

installlicense files/LICENSE

builddeb
