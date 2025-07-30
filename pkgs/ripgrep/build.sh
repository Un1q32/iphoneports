#!/bin/sh
set -e
. ../../lib.sh

(
cd src
SDKROOT="$_SDK" cargo build --target "$_RUSTTARGET" --release -j "$_JOBS"
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp "target/$_RUSTTARGET/release/rg" "$_PKGROOT/pkg/var/usr/bin"
)

strip_and_sign pkg/var/usr/bin/rg

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/UNLICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
if [ "$_SUBSYSTEM" = "ios" ] && [ "$_CPU" = "armv6" ]; then
    sed -i "/^Depends:/ s/$/, firmware (>= 3.0)/" pkg/DEBIAN/control
fi
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
