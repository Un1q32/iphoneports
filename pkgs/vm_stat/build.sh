#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
"$_TARGET-cc" vm_stat.c -o vm_stat -Os -flto -Wno-format
mkdir -p "$_DESTDIR/var/usr/bin"
cp vm_stat "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/vm_stat"

installlicense files/LICENSE

builddeb
