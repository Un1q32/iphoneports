#!/bin/sh -e
(
cd src || exit 1
ctags -w ./*.[ch]
"$_TARGET-cc" -O3 -flto buffer.c chat.c command.c complete.c config.c edit.c filter.c handle.c input.c irc.c log.c ui.c url.c window.c xdg.c -o catgirl -std=c11 -lncurses -ltls
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp catgirl "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" catgirl 2>/dev/null || true
ldid -S"$_ENT" catgirl
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "catgirl-$_DPKGARCH.deb"
