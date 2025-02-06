#!/bin/sh -e
unset SUDO_PROMPT
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --sysconfdir=/var/usr/etc --with-rundir=/var/usr/run/sudo --with-vardir=/var/usr/db/sudo --with-passprompt="Password:" --disable-tmpfiles.d --with-env-editor --with-editor='nano:vim:vi' --enable-zlib --enable-openssl ax_cv_check_cflags___static_libgcc=no
"$_MAKE" -j"$_JOBS"
fakeroot "$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
"$_TARGET-strip" bin/sudo bin/cvtsudoers bin/sudoreplay sbin/sudo_logsrvd sbin/sudo_sendlog sbin/visudo libexec/sudo/libsudo_util.0.dylib libexec/sudo/*.so 2>/dev/null || true
ldid -S"$_ENT" bin/sudo bin/cvtsudoers bin/sudoreplay sbin/sudo_logsrvd sbin/sudo_sendlog sbin/visudo libexec/sudo/libsudo_util.0.dylib libexec/sudo/*.so
chmod 4755 bin/sudo
)

mkdir -p pkg/usr/libexec/iphoneports
mv pkg/var/usr/bin/sudo pkg/usr/libexec/iphoneports
ln -s ../../../../usr/libexec/iphoneports/sudo pkg/var/usr/bin/sudo

cp files/sudoers pkg/var/usr/etc/sudoers
chmod 440 pkg/var/usr/etc/sudoers

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "sudo-$_DPKGARCH.deb"
