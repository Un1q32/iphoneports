#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
for src in ifconfig.c ifmedia.c; do
  "$_TARGET-cc" -c "$src" -Os -flto -DUSE_IF_MEDIA -DINET6 -DNO_IPX -Wno-deprecated-non-prototype -Wno-extra-tokens &
done
wait
"$_TARGET-cc" -o ifconfig -Os -flto ./*.o
mkdir -p "$_DESTDIR/var/usr/sbin"
cp ifconfig "$_DESTDIR/var/usr/sbin"
)

strip_and_sign "$_DESTDIR/var/usr/sbin/ifconfig"

installlicense files/LICENSE

builddeb
