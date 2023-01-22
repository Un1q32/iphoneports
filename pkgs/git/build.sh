#!/bin/sh
(
cd source || exit 1
ac_cv_snprintf_returns_bogus=y ac_cv_iconv_omits_bom=y ac_cv_fread_reads_directories=y ./configure --host="$_TARGET" --prefix=/usr
"$_MAKE" -j4
"$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package git-2.39.1.deb
