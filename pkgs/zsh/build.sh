#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --enable-etcdir=/var/usr/etc/zsh \
    --enable-zshenv=/var/usr/etc/zsh/zshenv \
    --enable-zlogin=/var/usr/etc/zsh/zlogin \
    --enable-zlogout=/var/usr/etc/zsh/zlogout \
    --enable-zprofile=/var/usr/etc/zsh/zprofile \
    --enable-zshrc=/var/usr/etc/zsh/zshrc \
    --enable-zsh-secure-free \
    --enable-multibyte \
    --enable-pcre \
    PCRECONF=true \
    LIBS="-lpcre"
sed -i -e '/^name=zsh\/regex/ s/link=no/link=static/' -e '/^name=zsh\/pcre/ s/link=no/link=static/' config.modules
make prep
make -j"$_JOBS"
make DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf bin/zsh-5.9 share/man
strip_and_sign bin/zsh
mkdir -p etc/zsh
)

cp files/zprofile pkg/var/usr/etc/zsh

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENCE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
