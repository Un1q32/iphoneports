#!/bin/sh
(
cd source || exit 1
"$_MAKE" CC="$_TARGET-clang" RANLIB="$_TARGET-ranlib" PREFIX="$_PKGROOT/package/usr" install -j8
)

(
cd package || exit 1
mv usr/bin .
rm -rf usr/man bin/bzcmp bin/bzegrep bin/bzfgrep bin/bzless
ln -s bzdiff bin/bzcmp
ln -s bzgrep bin/bzegrep
ln -s bzgrep bin/bzfgrep
ln -s bzmore bin/bzless
"$_TARGET-strip" -x bin/bzip2
"$_TARGET-strip" -x bin/bunzip2
"$_TARGET-strip" -x bin/bzcat
"$_TARGET-strip" -x bin/bzip2recover
ldid -S"$_BSROOT/entitlements.xml" bin/bzip2
ldid -S"$_BSROOT/entitlements.xml" bin/bunzip2
ldid -S"$_BSROOT/entitlements.xml" bin/bzcat
ldid -S"$_BSROOT/entitlements.xml" bin/bzip2recover
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package bzip2-1.0.8.deb
