#!/bin/sh
(
cd source || exit 1
./configure --host=arm-apple-darwin9 --prefix=/usr --sysconfdir=/etc
make -j4
make DESTDIR=../../package install
)


(
for nanorc in files/syntax/*.nanorc; do
    cp -a "$nanorc" package/usr/share/nano/
done
cp files/nanorc package/etc
cd package || exit 1
arm-apple-darwin9-strip -x usr/bin/nano
ldid -S usr/bin/nano
)

cp -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package nano-7.1.deb
