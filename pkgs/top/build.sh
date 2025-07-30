#!/bin/sh
# shellcheck disable=2086
set -e
. ../../lib.sh

(
cd src
if [ "$_SUBSYSTEM" = "ios" ] && [ "$_TRUEOSVER" -lt 20000 ]; then
    libutil="$_PKGROOT/files/humanize_number.c"
else
    libutil="-lutil"
fi
"$_TARGET-cc" -Os -flto top.c libtop.c log.c samp.c disp.c ch.c dch.c -o top -DTOP_DEPRECATED -Wno-invalid-pp-token -Wno-implicit-function-declaration -Wno-constant-conversion -Wno-tautological-constant-out-of-range-compare -lncurses -lpanel -framework IOKit -framework CoreFoundation "$libutil"
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp top "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
strip_and_sign top
chmod 4755 top
)

mkdir -p pkg/usr/libexec/iphoneports
mv pkg/var/usr/bin/top pkg/usr/libexec/iphoneports/top
ln -s ../../../../usr/libexec/iphoneports/top pkg/var/usr/bin/top

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"
if [ "$_SUBSYSTEM" = "ios" ] && [ "$_TRUEOSVER" -lt 20000 ]; then
    cp files/LICENSE-LIBBSD "pkg/var/usr/share/licenses/$_PKGNAME"
fi

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
