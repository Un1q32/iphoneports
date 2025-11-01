#!/bin/sh
. ../../files/lib.sh

mkdir -p "$_DESTDIR/var/usr/bin"
cp "$_SRCDIR/neofetch" "$_DESTDIR/var/usr/bin"

installlicense "$_SRCDIR/LICENSE.md"

builddeb
