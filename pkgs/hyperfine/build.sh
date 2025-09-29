#!/bin/sh
set -e
. ../../files/lib.sh

(
cd src
SDKROOT="$_SDK" cargo build --target "$_RUSTTARGET" --release -j "$_JOBS"
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp "target/$_RUSTTARGET/release/hyperfine" "$_PKGROOT/pkg/var/usr/bin"
)

strip_and_sign pkg/var/usr/bin/hyperfine

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE-* "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
