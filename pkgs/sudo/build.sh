#!/bin/sh
. ../../files/lib.sh

(
unset SUDO_PROMPT
cd "$_SRCDIR"
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --sysconfdir=/var/usr/etc \
    --with-rundir=/var/usr/run/sudo \
    --with-vardir=/var/usr/db/sudo \
    --with-passprompt='Password:' \
    --disable-tmpfiles.d \
    --with-env-editor \
    --with-editor='nano:vim:vi' \
    --enable-zlib \
    --enable-openssl \
    ax_cv_check_cflags___static_libgcc=no
make
fakeroot "$_MAKE" DESTDIR="$_DESTDIR" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf share
strip_and_sign bin/sudo bin/cvtsudoers bin/sudoreplay sbin/sudo_logsrvd sbin/sudo_sendlog sbin/visudo libexec/sudo/libsudo_util.0.dylib libexec/sudo/*.so
chmod 4755 bin/sudo
)

installsuid "$_DESTDIR/var/usr/bin/sudo"

cp files/sudoers "$_DESTDIR/var/usr/etc/sudoers"
chmod 440 "$_DESTDIR/var/usr/etc/sudoers"

installlicense "$_SRCDIR/LICENSE.md"

builddeb
