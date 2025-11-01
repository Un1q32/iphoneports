#!/bin/sh
. ../../files/lib.sh

if [ "$_SUBSYSTEM" = "macos" ] && [ "$_TRUEOSVER" -lt 1050 ]; then
    printf 'ps requires at least Mac OS X 10.5\n'
    mkdir pkg
    exit 0
fi

(
cd "$_SRCDIR"
for src in ps.c print.c nlist.c tasks.c keyword.c; do
    "$_TARGET-cc" -Os -flto -c "$src" -D'__FBSDID(x)=' -Wno-deprecated-non-prototype -Wno-#warnings &
done
wait
"$_TARGET-cc" -o ps -Os -flto ./*.o
mkdir -p "$_DESTDIR/var/usr/bin"
cp ps "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr/bin"
_ALWAYSSIGN=1
if [ "$_SUBSYSTEM" = "macos" ]; then
    _ENTITLEMENTS="$_PKGROOT/files/macos-entitlements.xml"
else
    _ENTITLEMENTS="$_PKGROOT/files/ios-entitlements.xml"
fi
strip_and_sign ps
chmod 4755 ps
)

installsuid "$_DESTDIR/var/usr/bin/ps"

installlicense files/LICENSE

builddeb
