#!/bin/sh
. ../../files/lib.sh

(
cd "$_SRCDIR"
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

strip_and_sign "$_DESTDIR/var/usr/bin/doas"
chmod 4755 "$_DESTDIR/var/usr/bin/doas"

installsuid "$_DESTDIR/var/usr/bin/doas"

mkdir -p "$_DESTDIR/var/usr/etc/pam.d"
cp files/doas.pam "$_DESTDIR/var/usr/etc/pam.d/doas"
cp files/doas.conf "$_DESTDIR/var/usr/etc"
chmod 440 "$_DESTDIR/var/usr/etc/doas.conf"

installlicense "$_SRCDIR/LICENSE"

builddeb
