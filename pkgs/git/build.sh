#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-libpcre2 --with-curl ac_cv_snprintf_returns_bogus=y ac_cv_iconv_omits_bom=y ac_cv_fread_reads_directories=y
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install INSTALL_SYMLINKS=y
)

(
cd pkg/var/usr || exit 1
for bin in bin/git bin/git-shell bin/scalar libexec/git-core/git-remote-http libexec/git-core/git-sh-i18n--envsubst libexec/git-core/git-http-backend libexec/git-core/git-http-fetch libexec/git-core/git-imap-send libexec/git-core/git-daemon; do
    "$_TARGET-strip" "$bin" > /dev/null 2>&1
    ldid -S"$_BSROOT/ent.xml" "$bin"
done
)

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg git.deb
