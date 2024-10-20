#!/bin/sh
mkdir -p src/build src/tmpbin

sed -e "s|@CC@|$_TARGET-cc|g" -e "s|@CXX@|$_TARGET-c++|g" -e "s|@AR@|$_TARGET-ar|g" -e "s|@RANLIB@|$_TARGET-ranlib|g" -e "s|@SDK@|$_SDK|g" files/iphoneports.meson > src/iphoneports.meson

[ "$_INSTALLNAMETOOL" != "install_name_tool" ] && printf '%s' "\
#!/bin/sh
exec \"$_INSTALLNAMETOOL\" \"\$@\"
" > src/tmpbin/install_name_tool && chmod +x src/tmpbin/install_name_tool

[ "$_OTOOL" != "otool" ] && printf '%s' "\
#!/bin/sh
exec \"$_OTOOL\" \"\$@\"
" > src/tmpbin/otool && chmod +x src/tmpbin/otool

export PATH="$_PKGROOT/src/tmpbin:$PATH"

(
cd src/build || exit 1
meson setup .. --cross-file="$_PKGROOT/src/iphoneports.meson" --prefix=/var/usr -Denable_asm=false -Denable_tests=false
DESTDIR="$_PKGROOT/pkg" ninja install -j8
)

(
cd pkg/var/usr || exit 1
"$_TARGET-strip" bin/dav1d lib/libdav1d.7.dylib 2>/dev/null
ldid -S"$_ENT" bin/dav1d lib/libdav1d.7.dylib
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg dav1d.deb
