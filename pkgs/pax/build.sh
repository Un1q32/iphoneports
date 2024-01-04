#!/bin/sh
(
cd src || exit 1
"$_TARGET-cc" -O2 -o pax pax.c tar.c cpio.c options.c cache.c ftree.c tables.c getoldopt.c ar_io.c pat_rep.c pax_format.c tty_subs.c ar_subs.c sel_subs.c buf_subs.c file_subs.c gen_subs.c -D'__FBSDID(x)='
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
cp pax "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
llvm-strip pax
ldid -S"$_ENT" pax
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg pax.deb
