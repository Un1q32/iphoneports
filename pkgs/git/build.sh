#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-libpcre2 --with-curl --with-openssl --with-zlib CURL_CONFIG="$_SDK/var/usr/bin/curl-config" ac_cv_snprintf_returns_bogus=y ac_cv_iconv_omits_bom=y ac_cv_fread_reads_directories=y
cpu="${_TARGET%%-*}"
"$_MAKE" install DESTDIR="$_PKGROOT/pkg" INSTALL_SYMLINKS=y CSPRNG_METHOD=openssl uname_M="$cpu" uname_R= uname_S= uname_O= uname_V= -j8
)

(
cd pkg/var/usr || exit 1
"$_TARGET-strip" bin/git bin/git-shell bin/scalar libexec/git-core/git-remote-http libexec/git-core/git-sh-i18n--envsubst libexec/git-core/git-http-backend libexec/git-core/git-http-fetch libexec/git-core/git-imap-send libexec/git-core/git-daemon 2>/dev/null
ldid -S"$_ENT" bin/git bin/git-shell bin/scalar libexec/git-core/git-remote-http libexec/git-core/git-sh-i18n--envsubst libexec/git-core/git-http-backend libexec/git-core/git-http-fetch libexec/git-core/git-imap-send libexec/git-core/git-daemon
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg git.deb
