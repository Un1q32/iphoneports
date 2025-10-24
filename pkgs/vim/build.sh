#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

(
cd src
if [ "$_SUBSYSTEM" = "ios" ] && [ "$_TRUEOSVER" -lt 20000 ]; then
    ipv6='vim_cv_ipv6_networking=no'
fi
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --with-tlib=ncurses \
    --disable-xattr \
    --with-compiledby=iPhonePorts \
    STRIP=true \
    vim_cv_toupper_broken=no \
    vim_cv_terminfo=yes \
    vim_cv_tgetent=zero \
    vim_cv_getcwd_broken=no \
    vim_cv_timer_create=no \
    vim_cv_timer_create_with_lrt=no \
    vim_cv_stat_ignores_slash=no \
    vim_cv_memmove_handles_overlap=yes \
    vim_cv_uname_output=generic \
    $ipv6 \
    PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig"
make install DESTDIR="$_PKGROOT/pkg" -j"$_JOBS"
)

(
cd pkg/var/usr
rm -rf bin/xxd share/applications share/icons share/man
strip_and_sign bin/vim
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
