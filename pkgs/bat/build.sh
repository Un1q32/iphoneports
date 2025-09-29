#!/bin/sh
set -e
. ../../files/lib.sh

# hack to make bat not include the iphoneports git rev
mkdir -p "$_PKGROOT/src/iphoneports-fakebin"
printf '#!/bin/sh\nexit 1\n' > "$_PKGROOT/src/iphoneports-fakebin/git"
chmod +x "$_PKGROOT/src/iphoneports-fakebin/git"
export PATH="$_PKGROOT/src/iphoneports-fakebin:$PATH"

(
cd src
SDKROOT="$_SDK" \
    TARGET_CC="$_TARGET-cc" \
    TARGET_PKG_CONFIG=pkg-config \
    PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" \
    PKG_CONFIG_SYSROOT_DIR="$_SDK" \
    LIBGIT2_NO_VENDOR=1 \
    cargo build --target "$_RUSTTARGET" --release -j "$_JOBS" \
    --config 'patch.crates-io.cc.git="https://github.com/Un1q32/cc-rs.git"' \
    --config 'patch.crates-io.cc.branch="1.0.83"'
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp "target/$_RUSTTARGET/release/bat" "$_PKGROOT/pkg/var/usr/bin"
)

strip_and_sign pkg/var/usr/bin/bat

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE-* "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
