#!/bin/sh
set -e
. ../../files/lib.sh

(
cd src
SDKROOT="$_SDK" \
    TARGET_PKG_CONFIG=pkg-config \
    PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" \
    PKG_CONFIG_SYSROOT_DIR="$_SDK" \
    cargo build --target "$_RUSTTARGET" --release --features 'pcre2' -j "$_JOBS"
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp "target/$_RUSTTARGET/release/rg" "$_PKGROOT/pkg/var/usr/bin"
)

strip_and_sign pkg/var/usr/bin/rg

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/UNLICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
