#!/bin/sh -e
(
cd src/pam || exit 1
autoconf
ln -s . pam
./configure --prefix=/var/usr --enable-read-both-confs --enable-giant-libpam --enable-fakeroot="$_PKGROOT/pkg" --enable-sconfigdir=/var/usr/etc/pam --disable-libcrack ac_cv_header_features_h=no
"$_MAKE" CC="$_TARGET-cc" AR="$_TARGET-ar" RANLIB="$_TARGET-ranlib" LD="$_TARGET-ld"
"$_MAKE" install
)

(
cd pkg || exit 1
mv usr/include var/usr
rm -rf usr
ln -s pam var/usr/include/security
cd var/usr/lib || exit 1
mv libpam.1.0.dylib libpam.1.dylib
"$_TARGET-strip" libpam.1.dylib security/*.so 2>/dev/null || true
ldid -S"$_ENT" libpam.1.dylib security/*.so
)

(
cd src/modules || exit 1
for module in launchd unix uwtmp; do
    "$_TARGET-cc" -bundle -o "pam_${module}.so" "pam_${module}"/*.c -I"$_PKGROOT/pkg/var/usr/include" "$_PKGROOT/pkg/var/usr/lib/libpam.dylib" -w
done
"$_TARGET-strip" ./*.so 2>/dev/null || true
ldid -S"$_ENT" ./*.so
cp ./*.so "$_PKGROOT/pkg/var/usr/lib/security"
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg pam.deb
