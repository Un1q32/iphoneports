#!/bin/sh
(
cd src || exit 1
ctags -w ./*.[ch]
"$_TARGET-cc" -O2 buffer.c chat.c command.c complete.c config.c edit.c filter.c handle.c input.c irc.c log.c ui.c url.c window.c xdg.c "$_PKGROOT/files/compat.c" -include "$_PKGROOT/files/compat.h" -o catgirl -std=c11 -lncurses -ltls
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp catgirl "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" catgirl > /dev/null 2>&1
ldid -S"$_ENT" catgirl
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg catgirl.deb
