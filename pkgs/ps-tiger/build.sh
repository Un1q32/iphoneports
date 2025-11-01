#!/bin/sh
. ../../files/lib.sh

if { [ "$_SUBSYSTEM" = "macos" ] && [ "$_OSVER" -ge 1050 ]; } ||
    [ "$_SUBSYSTEM" != "macos" ]; then
    printf 'ps-tiger is only for Mac OS X 10.4\n'
    mkdir "$_DESTDIR"
    exit 0
fi

(
cd "$_SRCDIR"
for src in ps.c print.c nlist.c tasks.c keyword.c; do
    "$_TARGET-cc" -Os -flto -c "$src" -D'__FBSDID(x)=' -w -Wno-implicit-int &
done
wait
"$_TARGET-cc" -o ps -Os -flto ./*.o
mkdir -p "$_DESTDIR/var/usr/bin"
cp ps "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr/bin"
_ALWAYSSIGN=1
_ENTITLEMENTS="$_PKGROOT/files/entitlements.xml"
strip_and_sign ps
chmod 4755 ps
)

installsuid "$_DESTDIR/var/usr/bin/ps"

installlicense files/LICENSE

builddeb
