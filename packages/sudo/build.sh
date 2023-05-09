#!/bin/sh
(
cd source || exit 1
./configure --host="$_TARGET" --exec-prefix=/usr --sysconfdir=/etc --includedir=/usr/include --with-passprompt="Password:" --enable-zlib --with-env-editor ax_cv_check_cflags___static_libgcc=no
"$_MAKE" -j8
fakeroot "$_MAKE" DESTDIR="$_PKGROOT/package" install
)

(
"$_CP" files/sudoers package/etc/sudoers
cd package || exit 1
rm -rf usr/local
"$_TARGET-strip" usr/bin/sudo > /dev/null 2>&1
"$_TARGET-strip" usr/bin/cvtsudoers > /dev/null 2>&1
"$_TARGET-strip" usr/bin/sudoreplay > /dev/null 2>&1
"$_TARGET-strip" usr/sbin/sudo_logsrvd > /dev/null 2>&1
"$_TARGET-strip" usr/sbin/sudo_sendlog > /dev/null 2>&1
"$_TARGET-strip" usr/sbin/visudo > /dev/null 2>&1
"$_TARGET-strip" usr/libexec/sudo/libsudo_util.0.dylib > /dev/null 2>&1
"$_TARGET-strip" usr/libexec/sudo/audit_json.so > /dev/null 2>&1
"$_TARGET-strip" usr/libexec/sudo/group_file.so > /dev/null 2>&1
"$_TARGET-strip" usr/libexec/sudo/sudoers.so > /dev/null 2>&1
"$_TARGET-strip" usr/libexec/sudo/sudo_intercept.so > /dev/null 2>&1
"$_TARGET-strip" usr/libexec/sudo/sudo_noexec.so > /dev/null 2>&1
"$_TARGET-strip" usr/libexec/sudo/system_group.so > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" usr/bin/sudo
ldid -S"$_BSROOT/ent.xml" usr/bin/cvtsudoers
ldid -S"$_BSROOT/ent.xml" usr/bin/sudoreplay
ldid -S"$_BSROOT/ent.xml" usr/sbin/sudo_logsrvd
ldid -S"$_BSROOT/ent.xml" usr/sbin/sudo_sendlog
ldid -S"$_BSROOT/ent.xml" usr/sbin/visudo
ldid -S"$_BSROOT/ent.xml" usr/libexec/sudo/libsudo_util.0.dylib
ldid -S"$_BSROOT/ent.xml" usr/libexec/sudo/audit_json.so
ldid -S"$_BSROOT/ent.xml" usr/libexec/sudo/group_file.so
ldid -S"$_BSROOT/ent.xml" usr/libexec/sudo/sudoers.so
ldid -S"$_BSROOT/ent.xml" usr/libexec/sudo/sudo_intercept.so
ldid -S"$_BSROOT/ent.xml" usr/libexec/sudo/sudo_noexec.so
ldid -S"$_BSROOT/ent.xml" usr/libexec/sudo/system_group.so
chmod 4755 usr/bin/sudo
)

case "$_TARGET" in
    *64*)
        debname="sudo-arm64.deb"
        "$_CP" -r files/DEBIAN-arm64 package/DEBIAN
    ;;
    *)
        debname="sudo.deb"
        "$_CP" -r DEBIAN package
    ;;
esac

dpkg-deb -b --root-owner-group -Zgzip package "$debname"
