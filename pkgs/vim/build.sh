#!/bin/sh
set -e
. ../../lib.sh
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --with-tlib=ncurses --disable-xattr --with-compiledby=iPhonePorts STRIP=true vim_cv_toupper_broken=no vim_cv_terminfo=yes vim_cv_tgetent=zero vim_cv_getcwd_broken=no vim_cv_timer_create=no vim_cv_timer_create_with_lrt=no vim_cv_stat_ignores_slash=no vim_cv_memmove_handles_overlap=yes vim_cv_uname_output=generic
"$_MAKE" install DESTDIR="$_PKGROOT/pkg" -j"$_JOBS"
)

(
cd pkg/var/usr
rm -rf bin/xxd share/applications share/icons share/man
strip_and_sign bin/vim
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
