#!/bin/sh
. ../../files/lib.sh

(
cd src
"$_TARGET-c++" -std=gnu++11 -Os -flto ldid.cpp -o ldid -lplist-2.0 -lcrypto -DLDID_VERSION='"2.1.5-procursus7"'
mkdir -p "$_DESTDIR/var/usr/bin"
cp ldid "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr/bin"
ln -s ldid ldid2
strip_and_sign ldid
)

installlicense "$_SRCDIR/COPYING"

builddeb
