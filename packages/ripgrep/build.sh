#!/bin/sh
cargover="$(cargo --version)"
case "$cargover" in
    *nightly*) ;;
    *) echo "cargo nightly required" && exit 1 ;;
esac

(
cd source || exit 1
sed -i 's/#!\[deny(missing_docs)\]//g' crates/grep/src/lib.rs
cargo build --release --target armv7-apple-ios -Zbuild-std
mkdir -p "$_PKGROOT/package/usr/bin"
"$_CP" target/armv7-apple-ios/release/rg "$_PKGROOT/package/usr/bin/rg"
)

(
cd package || exit 1
"$_TARGET-strip" usr/bin/rg > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" usr/bin/rg
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package ripgrep.deb
