#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
make install CXX="$_TARGET-c++" PREFIX=/var/usr FILESDIR=/var/usr/share/cppcheck DESTDIR="$_DESTDIR" HAVE_RULES=yes uname_S=Darwin -j"$_JOBS" PCRE_CONFIG="$_SDK/var/usr/bin/pcre-config"
)

strip_and_sign "$_DESTDIR/var/usr/bin/cppcheck"

installlicense "$_SRCDIR/COPYING"

builddeb
