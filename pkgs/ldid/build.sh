#!/bin/sh
(
cd src || exit 1
"$_TARGET-c++" -O2 ldid.cpp -o ldid -lplist-2.0 -lcrypto -DLDID_VERSION='"2.1.5-procursus7"'
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp ldid "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
ln -s ldid ldid2
llvm-strip ldid
ldid -S"$_ENT" ldid
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg ldid.deb
