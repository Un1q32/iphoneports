#!/bin/sh
. ../../files/lib.sh

mkdir -p "$_DESTDIR/var/usr/etc/ssl"
cp "$_SRCDIR/cert.pem" "$_DESTDIR/var/usr/etc/ssl"

builddeb
