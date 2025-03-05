#!/bin/sh -e
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --enable-etcdir=/var/usr/etc/zsh --enable-zshenv=/var/usr/etc/zsh/zshenv --enable-zlogin=/var/usr/etc/zsh/zlogin --enable-zlogout=/var/usr/etc/zsh/zlogout --enable-zprofile=/var/usr/etc/zsh/zprofile --enable-zshrc=/var/usr/etc/zsh/zshrc --enable-zsh-secure-free --enable-multibyte --enable-pcre PCRECONF=true LIBS="-lpcre"
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf bin/zsh-5.9 share/man
"$_TARGET-strip" bin/zsh 2>/dev/null || true
ldid -S"$_ENT" bin/zsh
mkdir -p etc/zsh
)

cp files/zprofile pkg/var/usr/etc/zsh

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENCE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
