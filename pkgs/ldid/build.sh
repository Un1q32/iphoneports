#!/bin/sh
. ../../files/lib.sh

(
cd src
"$_TARGET-c++" -std=gnu++11 -Os -flto ldid.cpp -o ldid -lplist-2.0 -lcrypto -DLDID_VERSION='"2.1.5-procursus7"'
mkdir -p "$_DESTDIR/var/usr/bin"
cp ldid "$_DESTDIR/var/usr/bin"
)

strip_and_sign "$_DESTDIR/var/usr/bin/ldid"
ln -s ldid "$_DESTDIR/var/usr/bin/ldid2"

installlicense "$_SRCDIR/COPYING"

builddeb
