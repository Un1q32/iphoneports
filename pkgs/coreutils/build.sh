#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --enable-single-binary=symlinks
"$_MAKE" -j4
mkdir -p ../package/bin
mkdir -p ../package/usr/bin
mkdir -p ../package/usr/libexec
cp src/coreutils ../package/bin
cp src/libstdbuf.so ../package/usr/libexec
for i in [ b2sum base32 base64 basename basenc chcon chroot cksum comm csplit cut df dircolors dirname du env expand expr factor fmt fold head hostid id install join logname md5sum mkfifo nice nl nohup nproc numfmt od paste pathchk pinky pr printenv printf ptx link realpath runcon seq sha1sum sha224sum sha256sum sha384sum sha512sum shred shuf sort split stat stdbuf sum sync tac tail tee test timeout tr truncate tsort tty unexpand uniq unlink users wc who whoami yes; do
    ln -s ../../bin/coreutils ../package/usr/bin/"$i"
done
for i in chmod chown dir kill chgrp uname readlink stty ln date false ls echo vdir cat sleep mv rm mkdir pwd rmdir dd mknod mktemp true touch cp; do
    ln -s coreutils ../package/bin/"$i"
done
cp -p ../files/su ../package/bin
)

(
cd package || exit 1
"$_TARGET-strip" -x bin/coreutils
ldid -S"$_BSROOT/entitlements.xml" bin/coreutils
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package coreutils-9.1.deb
