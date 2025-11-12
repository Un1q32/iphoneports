#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd "$_SRCDIR"
if [ "$_SUBSYSTEM" != "ios" ] || [ "$_OSVER" -ge 20000 ]; then
    inet6='-DINET6'
fi
for src in ifconfig.c ifmedia.c; do
    "$_TARGET-cc" -c "$src" -Os -flto -DUSE_IF_MEDIA -DNO_IPX $inet6 -Wno-deprecated-non-prototype -Wno-extra-tokens &
done
wait
"$_TARGET-cc" -o ifconfig -Os -flto ./*.o
mkdir -p "$_DESTDIR/var/usr/sbin"
cp ifconfig "$_DESTDIR/var/usr/sbin"
)

strip_and_sign "$_DESTDIR/var/usr/sbin/ifconfig"

installlicense files/LICENSE

builddeb
