#!/bin/sh
(
cd src || exit 1
ctags -w ./*.[ch]
"$_TARGET-cc" "$_PKGROOT/files/compat.c" buffer.c chat.c command.c complete.c config.c edit.c filter.c handle.c input.c irc.c log.c ui.c url.c window.c xdg.c -o catgirl -std=c11 -Wno-implicit-function-declaration -lncursesw -ltls -D'explicit_bzero(b,l)=memset_s((b),(l),0,(l))'
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
