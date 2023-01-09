#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --prefix=/usr --sysconfdir=/etc
make -j4
make DESTDIR="$_PKGROOT/package" install
)

(
for nanorc in files/syntax/*.nanorc; do
    cp -a "$nanorc" package/usr/share/nano/
done
mkdir package/etc
cp files/nanorc package/etc
cd package || exit 1
"$_TARGET-strip" -x usr/bin/nano
ldid -S"$_BSROOT/entitlements.plist" usr/bin/nano
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package nano-7.1.deb
