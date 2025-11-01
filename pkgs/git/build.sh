#!/bin/sh
. ../../files/lib.sh

(
cd src
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --with-libpcre2 \
    --with-curl \
    --with-openssl \
    --with-zlib \
    CURL_CONFIG="$_SDK/var/usr/bin/curl-config" \
    ac_cv_snprintf_returns_bogus=no \
    ac_cv_iconv_omits_bom=no \
    ac_cv_fread_reads_directories=yes
make install DESTDIR="$_DESTDIR" INSTALL_SYMLINKS=y CSPRNG_METHOD=openssl uname_M="$_CPU" uname_R= uname_S= uname_O= uname_V= -j"$_JOBS"
)

(
cd "$_DESTDIR/var/usr"
rm -rf share/perl5
strip_and_sign \
    bin/git \
    bin/git-shell \
    bin/scalar \
    libexec/git-core/git-remote-http \
    libexec/git-core/git-sh-i18n--envsubst \
    libexec/git-core/git-http-backend \
    libexec/git-core/git-http-fetch \
    libexec/git-core/git-imap-send \
    libexec/git-core/git-daemon
)

installlicense "$_SRCDIR/COPYING"

builddeb
