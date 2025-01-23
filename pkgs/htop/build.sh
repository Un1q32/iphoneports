#!/bin/sh -e
(
cd src || exit 1
./autogen.sh
./configure --host="$_TARGET" --prefix=/var/usr --disable-unicode --disable-linux-affinity
"$_MAKE" -j"$_JOBS"
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp htop "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" htop 2>/dev/null || true
ldid -S"$_ENT" htop
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg htop.deb
