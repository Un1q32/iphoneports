#!/bin/sh
. ../../files/lib.sh

(
cd src
for src in ncal.c calendar.c easter.c; do
  "$_TARGET-cc" -c "$src" -Os -flto -I. -D'__FBSDID(x)=' &
done
wait
"$_TARGET-cc" -o ncal -Os -flto -lncurses ./*.o
mkdir -p "$_DESTDIR/var/usr/bin"
cp ncal "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr"/bin
strip_and_sign ncal
ln -s ncal cal
)

installlicense files/LICENSE

builddeb
