#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --enable-single-binary=symlinks
"$_MAKE" -j4
mkdir -p "$_PKGROOT/package/bin"
mkdir -p "$_PKGROOT/package/usr/bin"
mkdir -p "$_PKGROOT/package/usr/libexec"
"$_CP" src/coreutils "$_PKGROOT/package/bin"
"$_CP" src/libstdbuf.so "$_PKGROOT/package/usr/libexec"
for i in [ b2sum base32 base64 basename basenc chcon chroot cksum comm csplit cut df dircolors dirname du env expand expr factor fmt fold head hostid id install join logname md5sum mkfifo nice nl nohup nproc numfmt od paste pathchk pinky pr printenv printf ptx link realpath runcon seq sha1sum sha224sum sha256sum sha384sum sha512sum shred shuf sort split stat stdbuf sum sync tac tail tee test timeout tr truncate tsort tty unexpand uniq unlink users wc who whoami yes; do
    ln -s ../../bin/coreutils "$_PKGROOT/package/usr/bin/$i"
done
for i in chmod chown dir kill chgrp uname readlink stty ln date false ls echo vdir cat sleep mv rm mkdir pwd rmdir dd mknod mktemp true touch cp; do
    ln -s coreutils "$_PKGROOT/package/bin/$i"
done
"$_CP" -p ../files/su "$_PKGROOT/package/bin"
)

(
cd package || exit 1
"$_TARGET-strip" -x bin/coreutils
"$_TARGET-strip" -x usr/libexec/libstdbuf.so
ldid -S"$_BSROOT/entitlements.xml" bin/coreutils
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/libstdbuf.so
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package coreutils-9.1.deb
