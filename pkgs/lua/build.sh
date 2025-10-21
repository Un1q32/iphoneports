#!/bin/sh
. ../../files/lib.sh
(
cd src
"$_MAKE" PLAT=macosx INSTALL_TOP=/var/usr CC="$_TARGET-cc" RANLIB="$_TARGET-ranlib" AR="$_TARGET-ar rcu"
"$_MAKE" PLAT=macosx INSTALL_TOP="$_PKGROOT/pkg/var/usr" CC="$_TARGET-cc" RANLIB="$_TARGET-ranlib" AR="$_TARGET-ar rcu" install
)

(
cd pkg/var/usr
rm -rf man
strip_and_sign bin/lua bin/luac "$(realpath lib/liblua.dylib)"
)

mkdir -p pkg/var/usr/lib/pkgconfig
cp files/lua.pc pkg/var/usr/lib/pkgconfig/lua54.pc
ln -sf lua54.pc pkg/var/usr/lib/pkgconfig/lua5.4.pc
ln -sf lua54.pc pkg/var/usr/lib/pkgconfig/lua-5.4.pc
ln -sf lua54.pc pkg/var/usr/lib/pkgconfig/lua.pc

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp files/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
