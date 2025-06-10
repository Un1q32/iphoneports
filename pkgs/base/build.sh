#!/bin/sh
set -e
. ../../lib.sh

mkdir -p pkg/usr/local/bin pkg/usr/local/libexec/iphoneports pkg/var/usr/bin pkg/var/usr/etc/profile.d

(
cd pkg

"$_TARGET-cc" -Wall -Wextra -pedantic -std=c99 -Os -flto -o usr/local/bin/iphoneports-shell "$_PKGROOT/files/iphoneports-shell.c"
"$_TARGET-cc" -Wall -Wextra -pedantic -std=c99 -Os -flto -o usr/local/libexec/iphoneports/iphoneports-chsh "$_PKGROOT/files/iphoneports-chsh.c"

strip_and_sign usr/local/bin/iphoneports-shell usr/local/libexec/iphoneports/iphoneports-chsh
chmod 4755 usr/local/libexec/iphoneports/iphoneports-chsh
ln -s /usr/local/libexec/iphoneports/iphoneports-chsh var/usr/bin/iphoneports-chsh

cp "$_PKGROOT/files/profile" var/usr/etc
cp "$_PKGROOT/files/path-wrapper" var/usr/bin

for link in apt-cache apt-cdrom apt-config apt-extracttemplates apt-ftparchive apt-get apt-key apt-mark apt-sortpkgs dselect; do
    ln -s path-wrapper "var/usr/bin/$link"
done
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
if [ "$_CPU" = "armv6" ]; then
    sed -i '/^Depends:/ s/$/, firmware (>= 3.0)/' pkg/DEBIAN/control
elif [ "$_CPU" = "armv7" ]; then
    sed -i '/^Depends:/ s/$/, firmware (>= 3.1)/' pkg/DEBIAN/control
fi
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
