#!/bin/sh -e
(
cd src
"$_MAKE" PLAT=macosx INSTALL_TOP=/var/usr CC="$_TARGET-cc" RANLIB="$_TARGET-ranlib" AR="$_TARGET-ar rcu"
"$_MAKE" PLAT=macosx INSTALL_TOP="$_PKGROOT/pkg/var/usr" CC="$_TARGET-cc" RANLIB="$_TARGET-ranlib" AR="$_TARGET-ar rcu" install
)

(
cd pkg/var/usr
rm -rf man
"$_TARGET-strip" bin/lua bin/luac "$(realpath lib/liblua.dylib)" 2>/dev/null || true
ldid -S"$_ENT" bin/lua bin/luac "$(realpath lib/liblua.dylib)"
)

mkdir -p pkg/var/usr/lib/pkgconfig
cp files/lua.pc pkg/var/usr/lib/pkgconfig/lua54.pc
ln -sf lua54.pc pkg/var/usr/lib/pkgconfig/lua5.4.pc
ln -sf lua54.pc pkg/var/usr/lib/pkgconfig/lua-5.4.pc
ln -sf lua54.pc pkg/var/usr/lib/pkgconfig/lua.pc

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg lua.deb
