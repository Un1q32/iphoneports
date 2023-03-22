#!/bin/sh
(
cd source || exit 1
vim_cv_memcpy_handles_overlap=set vim_cv_bcopy_handles_overlap=set vim_cv_memmove_handles_overlap=set vim_cv_stat_ignores_slash=set vim_cv_timer_create=set vim_cv_getcwd_broken=set vim_cv_toupper_broken=set vim_cv_terminfo=set vim_cv_tgetent=zero ./configure --host="$_TARGET" --prefix=/usr --with-tlib=ncurses
"$_MAKE" -j8
"$_MAKE" DESTDIR="$_PKGROOT/package" STRIP="$_TARGET-strip" install > /dev/null 2>1
)

(
cd package || exit 1
rm -rf usr/share/man usr/share/icons usr/share/applications usr/bin/xxd
"$_TARGET-strip" usr/bin/vim > /dev/null 2>1
ldid -S"$_BSROOT/entitlements.xml" usr/bin/vim
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package vim-9.0.1402.deb
