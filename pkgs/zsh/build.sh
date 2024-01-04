#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --enable-etcdir=/var/usr/etc/zsh --enable-zshenv=/var/usr/etc/zsh/zshenv --enable-zlogin=/var/usr/etc/zsh/zlogin --enable-zlogout=/var/usr/etc/zsh/zlogout --enable-zprofile=/var/usr/etc/zsh/zprofile --enable-zshrc=/var/usr/etc/zsh/zshrc --enable-zsh-secure-free --enable-multibyte --enable-pcre PCRECONF=true LIBS="-lpcre"
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf bin/zsh-5.9 share/man
llvm-strip bin/zsh
ldid -S"$_ENT" bin/zsh
mkdir -p etc/zsh
)

cp files/zprofile pkg/var/usr/etc/zsh

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg zsh.deb
