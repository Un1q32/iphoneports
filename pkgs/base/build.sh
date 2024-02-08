#!/bin/sh

mkdir -p pkg/usr/bin pkg/var/usr/bin pkg/var/usr/etc/profile.d

(
cd pkg || exit 1

"$_TARGET-cc" -std=c89 -O2 -o usr/bin/iphoneports-shell "$_PKGROOT/files/iphoneports-shell.c"
llvm-strip usr/bin/iphoneports-shell
ldid -S"$_ENT" usr/bin/iphoneports-shell

cp "$_PKGROOT/files/profile" var/usr/etc
cp "$_PKGROOT/files/path-wrapper" var/usr/bin

for link in apt-cache apt-cdrom apt-config apt-extracttemplates apt-ftparchive apt-get apt-key apt-mark apt-sortpkgs dpkg dpkg-deb dpkg-divert dpkg-maintscript-helper dpkg-query dpkg-split dpkg-statoverride dpkg-trigger dselect update-alternatives; do
    ln -s path-wrapper "var/usr/bin/$link"
done
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg base.deb
