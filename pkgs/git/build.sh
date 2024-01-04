#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-libpcre2 --with-curl --with-openssl CURL_CONFIG="$_SDK/var/usr/bin/curl-config" ac_cv_snprintf_returns_bogus=y ac_cv_iconv_omits_bom=y ac_cv_fread_reads_directories=y
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install INSTALL_SYMLINKS=y
)

(
cd pkg/var/usr || exit 1
llvm-strip bin/git bin/git-shell bin/scalar libexec/git-core/git-remote-http libexec/git-core/git-sh-i18n--envsubst libexec/git-core/git-http-backend libexec/git-core/git-http-fetch libexec/git-core/git-imap-send libexec/git-core/git-daemon
ldid -S"$_ENT" bin/git bin/git-shell bin/scalar libexec/git-core/git-remote-http libexec/git-core/git-sh-i18n--envsubst libexec/git-core/git-http-backend libexec/git-core/git-http-fetch libexec/git-core/git-imap-send libexec/git-core/git-daemon
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg git.deb
