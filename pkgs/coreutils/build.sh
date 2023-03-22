#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --enable-single-binary=symlinks
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" install
mkdir -p "$_PKGROOT/package/bin" "$_PKGROOT/package/usr/sbin"
for i in chmod chown dir kill chgrp uname readlink stty ln date false ls echo vdir cat sleep mv rm mkdir pwd rmdir dd mknod mktemp true touch cp; do
    ln -s ../usr/bin/coreutils "$_PKGROOT/package/bin/$i"
done
ln -s ../bin/chown "$_PKGROOT/package/usr/sbin/chown"
ln -s ../bin/chroot "$_PKGROOT/package/usr/sbin/chroot"
"$_CP" -a ../files/su "$_PKGROOT/package/bin"
"$_CP" -a ../files/df "$_PKGROOT/package/usr/bin"
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" usr/bin/coreutils > /dev/null 2>1
"$_TARGET-strip" usr/bin/df -no_code_signature_warning > /dev/null 2>1
"$_TARGET-strip" bin/su -no_code_signature_warning > /dev/null 2>1
"$_TARGET-strip" usr/libexec/coreutils/libstdbuf.so > /dev/null 2>1
ldid -S"$_BSROOT/entitlements.xml" usr/bin/coreutils
ldid -S"$_BSROOT/entitlements.xml" usr/bin/df
ldid -S"$_BSROOT/entitlements.xml" bin/su
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/coreutils/libstdbuf.so
chmod 4555 "$_PKGROOT/package/bin/su"
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package coreutils-9.2.deb
