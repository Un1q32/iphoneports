#!/bin/sh
# shellcheck disable=2086
set -e
. ../../lib.sh
(
cd src/build_unix
if [ "$_CPU" = "armv6" ]; then
    mutex='--disable-mutexsupport'
fi
../dist/configure --host="$_TARGET" --prefix=/var/usr --disable-static --enable-cxx $mutex
"$_MAKE" -j"$_JOBS"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg"
)

(
cd pkg/var/usr
rm -rf docs
chmod u+w bin/*
strip_and_sign bin/*
for lib in lib/*.dylib; do
    [ -h "$lib" ] || strip_and_sign "$lib"
done
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
