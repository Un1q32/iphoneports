#!/bin/sh
. ../../files/lib.sh

(
cd src
for src in main.c io.c buf.c re.c glbl.c undo.c sub.c; do
  "$_TARGET-cc" -c -Os -flto "$src" -D'__FBSDID(x)=' &
done
wait
"$_TARGET-cc" -o ed -Os -flto ./*.o
mkdir -p "$_DESTDIR/var/usr/bin"
cp ed "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr"/bin
strip_and_sign ed
)

installlicense files/LICENSE

builddeb
