#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR/pam"
autoconf
ln -s . pam
./configure \
    --prefix=/var/usr \
    --enable-read-both-confs \
    --enable-giant-libpam \
    --enable-fakeroot="$_DESTDIR" \
    --enable-sconfigdir=/var/usr/etc/pam \
    --disable-libcrack \
    ac_cv_header_features_h=no
make CC="$_TARGET-cc" AR="$_TARGET-ar" RANLIB="$_TARGET-ranlib" LD="$_TARGET-ld"
make install
)

(
cd "$_DESTDIR"
mv usr/include var/usr
rm -rf usr
ln -s pam var/usr/include/security
cd var/usr/lib
mv libpam.1.0.dylib libpam.1.dylib
strip_and_sign libpam.1.dylib security/*.so
)

(
cd "$_SRCDIR/modules"
modules='unix uwtmp'
if { [ "$_SUBSYSTEM" = "ios" ] && [ "$_OSVER" -ge 20000 ]; } ||
    { [ "$_SUBSYSTEM" = "macos" ] && [ "$_OSVER" -ge 1050 ]; } ||
    { [ "$_SUBSYSTEM" != "macos" ] && [ "$_SUBSYSTEM" != "ios" ]; }; then
    modules="$modules launchd"
fi
for module in $modules; do
    "$_TARGET-cc" -bundle -o "pam_${module}.so" "pam_${module}"/*.c -I"$_DESTDIR/var/usr/include" "$_DESTDIR/var/usr/lib/libpam.dylib" -w
done
strip_and_sign ./*.so
cp ./*.so "$_DESTDIR/var/usr/lib/security"
)

installlicense "$_SRCDIR/pam/Copyright" files/*

builddeb
