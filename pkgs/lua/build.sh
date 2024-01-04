#!/bin/sh
(
cd src || exit 1
"$_MAKE" PLAT=macosx INSTALL_TOP=/var/usr CC="$_TARGET-cc" RANLIB="$_TARGET-ranlib"
"$_MAKE" PLAT=macosx INSTALL_TOP="$_PKGROOT/pkg/var/usr" CC="$_TARGET-cc" RANLIB="$_TARGET-ranlib" install
)

(
cd pkg/var/usr || exit 1
rm -rf man
llvm-strip bin/lua bin/luac
ldid -S"$_ENT" bin/lua bin/luac
)

mkdir -p pkg/var/usr/lib/pkgconfig
cp files/lua.pc pkg/var/usr/lib/pkgconfig/lua54.pc
ln -sf lua54.pc pkg/var/usr/lib/pkgconfig/lua5.4.pc
ln -sf lua54.pc pkg/var/usr/lib/pkgconfig/lua-5.4.pc
ln -sf lua54.pc pkg/var/usr/lib/pkgconfig/lua.pc

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg lua.deb
