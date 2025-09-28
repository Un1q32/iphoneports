#!/bin/sh
set -e
. ../../files/lib.sh
(
cd src/pam
autoconf
ln -s . pam
./configure --prefix=/var/usr --enable-read-both-confs --enable-giant-libpam --enable-fakeroot="$_PKGROOT/pkg" --enable-sconfigdir=/var/usr/etc/pam --disable-libcrack ac_cv_header_features_h=no
"$_MAKE" CC="$_TARGET-cc" AR="$_TARGET-ar" RANLIB="$_TARGET-ranlib" LD="$_TARGET-ld"
"$_MAKE" install
)

(
cd pkg
mv usr/include var/usr
rm -rf usr
ln -s pam var/usr/include/security
cd var/usr/lib
mv libpam.1.0.dylib libpam.1.dylib
strip_and_sign libpam.1.dylib security/*.so
)

(
cd src/modules
for module in launchd unix uwtmp; do
    "$_TARGET-cc" -bundle -o "pam_${module}.so" "pam_${module}"/*.c -I"$_PKGROOT/pkg/var/usr/include" "$_PKGROOT/pkg/var/usr/lib/libpam.dylib" -w
done
strip_and_sign ./*.so
cp ./*.so "$_PKGROOT/pkg/var/usr/lib/security"
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/pam/Copyright "pkg/var/usr/share/licenses/$_PKGNAME/LICENSE-BSD3"
cp files/* "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
