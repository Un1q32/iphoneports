#!/bin/sh
(
cd src || exit 1
./configure --host="$_TARGET" --prefix=/var/usr --sysconfdir=/var/usr/etc --with-passprompt="Password:" --enable-zlib=system --with-env-editor ax_cv_check_cflags___static_libgcc=no
"$_MAKE" -j8
fakeroot "$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr || exit 1
rm -rf share
for bin in bin/sudo bin/cvtsudoers bin/sudoreplay sbin/sudo_logsrvd sbin/sudo_sendlog sbin/visudo libexec/sudo/libsudo_util.0.dylib libexec/sudo/*.so; do
    "$_TARGET-strip" "$bin" > /dev/null 2>&1
    ldid -S"$_BSROOT/ent.xml" "$bin"
done
chmod 4755 bin/sudo
)

mkdir -p pkg/usr/libexec/iphoneports
mv pkg/var/usr/bin/sudo pkg/usr/libexec/iphoneports/sudo
ln -s /usr/libexec/iphoneports/sudo pkg/var/usr/bin/sudo

"$_CP" files/sudoers pkg/var/usr/etc/sudoers

case "$_TARGET" in
    *64*)
        debname="sudo64.deb"
        "$_CP" -r files/DEBIAN-arm64 pkg/DEBIAN
    ;;
    *)
        debname="sudo.deb"
        "$_CP" -r DEBIAN pkg
    ;;
esac

dpkg-deb -b --root-owner-group -Zgzip pkg "$debname"
