#!/bin/sh
(
cd source || exit 1
ac_cv_snprintf_returns_bogus=y ac_cv_iconv_omits_bom=y ac_cv_fread_reads_directories=y ./configure --host="$_TARGET" --prefix=/usr --with-libpcre2 --with-curl
"$_MAKE" -j8
INSTALL_SYMLINKS=y "$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
cd package || exit 1
for file in git git-shell scalar; do
    "$_TARGET-strip" usr/bin/$file > /dev/null 2>&1
    ldid -S"$_BSROOT/entitlements.xml" usr/bin/$file
done
for file in git-remote-http git-sh-i18n--envsubst git-http-backend git-http-fetch git-imap-send git-daemon; do
    "$_TARGET-strip" usr/libexec/git-core/$file > /dev/null 2>&1
    ldid -S"$_BSROOT/entitlements.xml" usr/libexec/git-core/$file
done
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package git-2.40.1.deb
