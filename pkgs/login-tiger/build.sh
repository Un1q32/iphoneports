#!/bin/sh
set -e
. ../../files/lib.sh

if [ "$_SUBSYSTEM" = "macos" ] && [ "$_TRUEOSVER" -ge 1050 ]; then
    printf 'login-tiger is only for Mac OS X 10.4\n'
    mkdir pkg
    exit 0
fi

(
cd src
"$_TARGET-cc" -o login -Os -flto login.c -DUSE_PAM -lpam -lbsm -w
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp login "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin
strip_and_sign login
chmod 4755 login
)

mkdir -p pkg/usr/local/libexec/iphoneports pkg/var/usr/etc/pam.d
mv pkg/var/usr/bin/login pkg/usr/local/libexec/iphoneports/login
ln -s ../../../../usr/local/libexec/iphoneports/login pkg/var/usr/bin/login
cp files/login.pam pkg/var/usr/etc/pam.d/login

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE-* "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
