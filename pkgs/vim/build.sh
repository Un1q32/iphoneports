#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --with-tlib=ncurses --disable-xattr --with-compiledby=iPhonePorts STRIP=true vim_cv_toupper_broken=no vim_cv_terminfo=yes vim_cv_tgetent=zero vim_cv_getcwd_broken=no vim_cv_timer_create=no vim_cv_timer_create_with_lrt=no vim_cv_stat_ignores_slash=no vim_cv_memmove_handles_overlap=yes
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf bin/xxd share/applications share/icons share/man
"$_TARGET-strip" bin/vim 2>/dev/null
ldid -S"$_ENT" bin/vim
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg vim.deb
