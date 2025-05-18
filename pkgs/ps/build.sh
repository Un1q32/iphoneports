#!/bin/sh -e
(
cd src
for src in ps.c print.c nlist.c tasks.c keyword.c; do
    "$_TARGET-cc" -Os -flto -c "$src" -D'__FBSDID(x)=' -Wno-deprecated-non-prototype -Wno-#warnings &
done
wait
"$_TARGET-cc" -o ps -Os -flto ./*.o
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp ps "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
if [ "$_SUBSYSTEM" = "macos" ]; then
    _ENTITLEMENTS="$_PKGROOT/files/macos-entitlements.xml"
else
    _ENTITLEMENTS="$_PKGROOT/files/ios-entitlements.xml"
fi
strip_and_sign ps
chmod 4755 ps
)

mkdir -p pkg/usr/local/libexec/iphoneports
mv pkg/var/usr/bin/ps pkg/usr/local/libexec/iphoneports
ln -s ../../../../usr/local/libexec/iphoneports/ps pkg/var/usr/bin/ps

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
