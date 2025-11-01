#!/bin/sh
. ../../files/lib.sh

(
cd src
yacc parse.y
"$_TARGET-cc" \
    -o doas \
    -Os -flto \
    doas.c \
    env.c \
    compat/execvpe.c \
    compat/reallocarray.c \
    y.tab.c \
    compat/bsd-closefrom.c \
    -lpam \
    -Icompat \
    -include compat/compat.h \
    -DUSE_PAM \
    -D__LINUX_PAM__ \
    -DDOAS_CONF='"/var/usr/etc/doas.conf"' \
    -DGLOBAL_PATH='"/var/usr/sbin:/var/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' \
    -DSAFE_PATH='"/var/usr/bin:/var/usr/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"'
sed -i 's,@DOAS_CONF@,/var/usr/etc/doas.conf,g' vidoas
mkdir -p "$_DESTDIR/var/usr/bin"
cp doas "$_DESTDIR/var/usr/bin"
cp vidoas "$_DESTDIR/var/usr/bin"
cp doasedit "$_DESTDIR/var/usr/bin"
)

(
cd "$_DESTDIR/var/usr"/bin
strip_and_sign doas
chmod 4755 doas
)

mkdir -p pkg/usr/local/libexec/iphoneports pkg/var/usr/etc/pam.d
mv pkg/var/usr/bin/doas pkg/usr/local/libexec/iphoneports
ln -s ../../../../usr/local/libexec/iphoneports/doas pkg/var/usr/bin/doas
cp files/doas.pam pkg/var/usr/etc/pam.d/doas
cp files/doas.conf pkg/var/usr/etc
chmod 440 pkg/var/usr/etc/doas.conf

installlicense "$_SRCDIR/LICENSE"

builddeb
