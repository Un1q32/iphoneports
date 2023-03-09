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
chmod 4555 "$_PKGROOT/package/bin/su"
)

(
cd package || exit 1
rm -rf usr/share
"$_TARGET-strip" usr/bin/coreutils
"$_TARGET-strip" -x usr/libexec/coreutils/libstdbuf.so
ldid -S"$_BSROOT/entitlements.xml" usr/bin/coreutils
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/coreutils/libstdbuf.so
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package coreutils-9.1.deb
