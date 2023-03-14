#!/bin/sh
(
cd source || exit 1
ac_cv_snprintf_returns_bogus=y ac_cv_iconv_omits_bom=y ac_cv_fread_reads_directories=y ./configure --host="$_TARGET" --prefix=/usr --with-libpcre2 --with-curl
"$_MAKE" -j8
INSTALL_SYMLINKS=y "$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
"$_TARGET-strip" usr/bin/git
"$_TARGET-strip" usr/bin/git-shell
"$_TARGET-strip" usr/bin/scalar
"$_TARGET-strip" usr/libexec/git-core/git-remote-http
"$_TARGET-strip" usr/libexec/git-core/git-sh-i18n--envsubst
"$_TARGET-strip" usr/libexec/git-core/git-http-backend
"$_TARGET-strip" usr/libexec/git-core/git-http-fetch
"$_TARGET-strip" usr/libexec/git-core/git-imap-send
"$_TARGET-strip" usr/libexec/git-core/git-daemon
ldid -S"$_BSROOT/entitlements.xml" usr/bin/git
ldid -S"$_BSROOT/entitlements.xml" usr/bin/git-shell
ldid -S"$_BSROOT/entitlements.xml" usr/bin/scalar
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/git-core/git-remote-http
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/git-core/git-sh-i18n--envsubst
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/git-core/git-http-backend
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/git-core/git-http-fetch
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/git-core/git-imap-send
ldid -S"$_BSROOT/entitlements.xml" usr/libexec/git-core/git-daemon
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package git-2.40.0.deb
