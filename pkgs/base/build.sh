#!/bin/sh
. ../../files/lib.sh

(
mkdir -p "$_DESTDIR"
cd "$_DESTDIR"
mkdir -p usr/local/bin var/usr/bin var/usr/etc/profile.d

"$_TARGET-cc" -Wall -Wextra -pedantic -std=c99 -Os -o usr/local/bin/iphoneports-shell "$_PKGROOT/files/iphoneports-shell.c"
"$_TARGET-cc" -Wall -Wextra -pedantic -std=c99 -Os -o var/usr/bin/iphoneports-chsh "$_PKGROOT/files/iphoneports-chsh.c"

strip_and_sign usr/local/bin/iphoneports-shell var/usr/bin/iphoneports-chsh
chmod 4755 var/usr/bin/iphoneports-chsh

installsuid var/usr/bin/iphoneports-chsh

cp "$_PKGROOT/files/profile" var/usr/etc
cp "$_PKGROOT/files/aliases.sh" var/usr/etc/profile.d
cp "$_PKGROOT/files/path-wrapper" var/usr/bin

for link in apt-cache apt-cdrom apt-config apt-extracttemplates apt-ftparchive apt-get apt-key apt-mark apt-sortpkgs dselect; do
    ln -s path-wrapper "var/usr/bin/$link"
done
)

builddeb
