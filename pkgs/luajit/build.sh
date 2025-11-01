#!/bin/sh
. ../../files/lib.sh

(
cd src
"$_TARGET-cc" -dM -E - < /dev/null | grep -q __LP64__ && arg=-m64
if [ "$_SUBSYSTEM" = "ios" ]; then
    sys='iOS'
else
    sys='Darwin'
fi
make amalg TARGET_SYS="$sys" HOST_CC="clang ${arg:--m32}" CROSS="$_TARGET-" BUILDMODE=dynamic CCOPT=-O3 PREFIX=/var/usr DESTDIR="$_DESTDIR" MACOSX_DEPLOYMENT_TARGET="$_MACVER" -j"$_JOBS"
make install PREFIX=/var/usr DESTDIR="$_DESTDIR" TARGET_SYS=Darwin
)

(
cd "$_DESTDIR/var/usr"
rm -rf share/man
ver="$(echo bin/luajit-2.1.*)"
ver="${ver#bin/luajit-2.1.}"
strip_and_sign "bin/luajit-2.1.$ver" "lib/libluajit-5.1.2.1.$ver.dylib"
)

installlicense src/COPYRIGHT

builddeb
