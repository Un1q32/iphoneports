#!/bin/sh -e
unset SUDO_PROMPT
(
cd src
./configure --host="$_TARGET" --prefix=/var/usr --sysconfdir=/var/usr/etc --with-rundir=/var/usr/run/sudo --with-vardir=/var/usr/db/sudo --with-passprompt="Password:" --disable-tmpfiles.d --with-env-editor --with-editor='nano:vim:vi' --enable-zlib --enable-openssl ax_cv_check_cflags___static_libgcc=no
"$_MAKE" -j"$_JOBS"
fakeroot "$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share
strip_and_sign bin/sudo bin/cvtsudoers bin/sudoreplay sbin/sudo_logsrvd sbin/sudo_sendlog sbin/visudo libexec/sudo/libsudo_util.0.dylib libexec/sudo/*.so
chmod 4755 bin/sudo
)

mkdir -p pkg/usr/local/libexec/iphoneports
mv pkg/var/usr/bin/sudo pkg/usr/local/libexec/iphoneports
ln -s ../../../../usr/local/libexec/iphoneports/sudo pkg/var/usr/bin/sudo

cp files/sudoers pkg/var/usr/etc/sudoers
chmod 440 pkg/var/usr/etc/sudoers

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE.md "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
