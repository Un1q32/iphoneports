#!/bin/sh
. ../../files/lib.sh
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_TARGET-cc" -Os -flto "$_PKGROOT/files/getusedmem.c" -o "$_PKGROOT/pkg/var/usr/bin/getusedmem"

strip_and_sign "$_PKGROOT/pkg/var/usr/bin/getusedmem"

builddeb
