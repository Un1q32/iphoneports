#!/bin/sh
(
cd source || exit 1
ax_cv_check_cflags___static_libgcc=no ./configure --host="$_TARGET" --exec-prefix=/usr --sysconfdir=/etc --includedir=/usr/include
"$_MAKE" -j4
fakeroot "$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
"$_CP" files/sudoers package/etc/sudoers
cd package || exit 1
rm -rf usr/local
"$_TARGET-strip" -x usr/bin/sudo
"$_TARGET-strip" -x usr/bin/cvtsudoers
"$_TARGET-strip" -x usr/bin/sudoreplay
"$_TARGET-strip" -x usr/sbin/sudo_logsrvd
"$_TARGET-strip" -x usr/sbin/sudo_sendlog
"$_TARGET-strip" -x usr/sbin/visudo
"$_TARGET-strip" -x usr/libexec/sudo/libsudo_util.0.dylib
ldid -S"$_BSROOT/entitlements.xml" usr/bin/sudo
ldid -S"$_BSROOT/entitlements.xml" usr/bin/cvtsudoers
ldid -S"$_BSROOT/entitlements.xml" usr/bin/sudoreplay
ldid -S"$_BSROOT/entitlements.xml" usr/sbin/sudo_logsrvd
ldid -S"$_BSROOT/entitlements.xml" usr/sbin/sudo_sendlog
ldid -S"$_BSROOT/entitlements.xml" usr/sbin/visudo
chmod 4755 usr/bin/sudo
)

"$_CP" -r DEBIAN package
dpkg-deb -b --root-owner-group -Zgzip package sudo-1.9.12p2.deb
