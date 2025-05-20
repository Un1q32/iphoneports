#!/bin/sh -e
set -e
. ../../lib.sh
(
cd src
ctags -w ./*.[ch]
"$_TARGET-cc" -O2 -flto buffer.c chat.c command.c complete.c config.c edit.c filter.c handle.c input.c irc.c log.c ui.c url.c window.c xdg.c -o catgirl -std=c11 -lncurses -ltls
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp catgirl "$_PKGROOT/pkg/var/usr/bin"
)

strip_and_sign pkg/var/usr/bin/catgirl

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg catgirl.deb
