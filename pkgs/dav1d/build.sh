#!/bin/sh
set -e
. ../../lib.sh
mkdir -p src/build src/tmpbin

case $_CPU in
    arm64*|aarch64*)
        cpu_family=aarch64
        asm=true
    ;;

    armv7*)
        cpu_family=arm
        asm=true
    ;;

    arm*)
        cpu_family=arm
        asm=false
    ;;

    x86_64*)
        cpu_family=x86_64
        asm=true
    ;;

    i386)
        cpu_family=x86
        asm=true
    ;;

    *)
        echo "UNSUPPORTED ARCHITECTURE"
        exit 1
    ;;
esac

sed -e "s|@CC@|$_TARGET-cc|g" \
    -e "s|@CXX@|$_TARGET-c++|g" \
    -e "s|@AR@|$_TARGET-ar|g" \
    -e "s|@RANLIB@|$_TARGET-ranlib|g" \
    -e "s|@SDK@|$_SDK|g" \
    -e "s|@CPU@|$_CPU|g" \
    -e "s|@CPU_FAMILY@|$cpu_family|g" \
    -e "s|@SUBSYSTEM@|$_SUBSYSTEM|g" \
    files/iphoneports.meson > src/iphoneports.meson

printf '%s' "\
#!/bin/sh
exec \"$(command -v "$_TARGET-install_name_tool")\" \"\$@\"
" > src/tmpbin/install_name_tool && chmod +x src/tmpbin/install_name_tool

printf '%s' "\
#!/bin/sh
exec \"$(command -v "$_TARGET-otool")\" \"\$@\"
" > src/tmpbin/otool && chmod +x src/tmpbin/otool

export PATH="$_PKGROOT/src/tmpbin:$PATH"

(
cd src/build
meson setup .. --cross-file="$_PKGROOT/src/iphoneports.meson" --prefix=/var/usr -Denable_asm="$asm" -Denable_tests=false
DESTDIR="$_PKGROOT/pkg" ninja -j"$_JOBS" install
)

(
cd pkg/var/usr
strip_and_sign bin/dav1d lib/libdav1d.7.dylib
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
