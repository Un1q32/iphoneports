#!/bin/sh
(
cd src || exit 1
yacc parse.y
"$_TARGET-cc" -o doas -O2 doas.c env.c compat/execvpe.c compat/reallocarray.c y.tab.c compat/bsd-closefrom.c -lpam -Icompat -include compat/compat.h -DUSE_PAM -D__LINUX_PAM__ -DDOAS_CONF='"/var/usr/etc/doas.conf"' -DGLOBAL_PATH='"/var/usr/sbin:/var/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:"'
sed -i 's,@DOAS_CONF@,/var/usr/etc/doas.conf,g' vidoas
mkdir -p "$_PKGROOT/pkg/var/usr/bin"
"$_CP" doas "$_PKGROOT/pkg/var/usr/bin"
"$_CP" vidoas "$_PKGROOT/pkg/var/usr/bin"
"$_CP" doasedit "$_PKGROOT/pkg/var/usr/bin"
)

(
cd pkg/var/usr/bin || exit 1
"$_TARGET-strip" doas > /dev/null 2>&1
ldid -S"$_BSROOT/ent.xml" doas
chmod 4755 doas
)

mkdir -p pkg/usr/bin/iphoneports pkg/etc/pam.d pkg/var/usr/etc
mv pkg/var/usr/bin/doas pkg/usr/bin/iphoneports
ln -s ../../../../usr/bin/iphoneports/doas pkg/var/usr/bin/doas
"$_CP" files/doas.pam pkg/etc/pam.d/doas
"$_CP" files/doas.conf pkg/var/usr/etc

"$_CP" -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg doas.deb
