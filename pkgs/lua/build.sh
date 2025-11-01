#!/bin/sh
. ../../files/lib.sh

(
cd src
make PLAT=macosx INSTALL_TOP=/var/usr CC="$_TARGET-cc" RANLIB="$_TARGET-ranlib" AR="$_TARGET-ar rcu"
make PLAT=macosx INSTALL_TOP="$_DESTDIR/var/usr" CC="$_TARGET-cc" RANLIB="$_TARGET-ranlib" AR="$_TARGET-ar rcu" install
)

(
cd "$_DESTDIR/var/usr"
rm -rf man
strip_and_sign bin/lua bin/luac "$(realpath lib/liblua.dylib)"
)

mkdir -p pkg/var/usr/lib/pkgconfig
cp files/lua.pc pkg/var/usr/lib/pkgconfig/lua54.pc
ln -sf lua54.pc pkg/var/usr/lib/pkgconfig/lua5.4.pc
ln -sf lua54.pc pkg/var/usr/lib/pkgconfig/lua-5.4.pc
ln -sf lua54.pc pkg/var/usr/lib/pkgconfig/lua.pc

installlicense files/LICENSE

builddeb
