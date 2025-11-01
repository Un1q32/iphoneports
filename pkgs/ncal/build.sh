#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
for src in ncal.c calendar.c easter.c; do
  "$_TARGET-cc" -c "$src" -Os -flto -I. -D'__FBSDID(x)=' &
done
wait
"$_TARGET-cc" -o ncal -Os -flto -lncurses ./*.o
mkdir -p "$_DESTDIR/var/usr/bin"
cp ncal "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/ncal"
ln -s ncal "$_DESTDIR/var/usr/bin/cal"

installlicense files/LICENSE

builddeb
