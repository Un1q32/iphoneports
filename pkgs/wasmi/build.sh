#!/bin/sh
. ../../files/lib.sh

# hack to make ripgrep not include the iphoneports git rev
mkdir -p "$_SRCDIR/iphoneports-fakebin"
printf '#!/bin/sh\nexit 1\n' > "$_SRCDIR/iphoneports-fakebin/git"
chmod +x "$_SRCDIR/iphoneports-fakebin/git"
export PATH="$_SRCDIR/iphoneports-fakebin:$PATH"

if ! supportsrust; then
    mkdir "$_DESTDIR"
    exit 0
fi

(
cd "$_SRCDIR"
SDKROOT="$_SDK" cargo build -p wasmi_cli --target "$_RUSTTARGET" --release -j "$_JOBS"
mkdir -p "$_DESTDIR/var/usr/bin"
cp "target/$_RUSTTARGET/release/wasmi" "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/wasmi"

installlicense "$_SRCDIR/LICENSE-MIT"

builddeb
