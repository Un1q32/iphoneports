#!/bin/sh
# shellcheck disable=2086
. ../../files/lib.sh

mkdir -p "$_PKGROOT/src/iphoneports-fakebin"
printf '#!/bin/sh\necho %s\n' "$_MACVER" > "$_PKGROOT/src/iphoneports-fakebin/sw_vers"
chmod +x "$_PKGROOT/src/iphoneports-fakebin/sw_vers"
export PATH="$_PKGROOT/src/iphoneports-fakebin:$PATH"

(
cd src
autoreconf -fi

(
mkdir _buildpython && cd _buildpython || exit 1
../configure --prefix="$_PKGROOT/src/buildpython" --without-ensurepip CC=clang
make install -j"$_JOBS"
)

if [ "$_SUBSYSTEM" = "ios" ] && [ "$_TRUEOSVER" -lt 20000 ]; then
    posix_spawn='ac_cv_func_posix_spawn=no ac_cv_func_posix_spawnp=no --disable-ipv6'
elif [ "$_SUBSYSTEM" = "macos" ] && [ "$_TRUEOSVER" -lt 1050 ]; then
    remote_debug='--without-remote-debug py_cv_module__remote_debugging=n/a'
fi
./configure \
    --host="$_TARGET" \
    --prefix=/var/usr \
    --build="$(clang -dumpmachine)" \
    --with-build-python="$_PKGROOT/src/buildpython/bin/python3" \
    --without-mimalloc \
    --with-lto=full \
    --enable-shared \
    --without-ensurepip \
    LDSHARED="$_TARGET-cc -shared -undefined dynamic_lookup" \
    MACHDEP=darwin \
    ac_sys_system=Darwin \
    ac_cv_buggy_getaddrinfo=no \
    ac_cv_file__dev_ptmx=yes \
    ac_cv_file__dev_ptc=no \
    PKG_CONFIG_LIBDIR="$_SDK/var/usr/lib/pkgconfig" \
    $posix_spawn \
    $remote_debug
make DESTDIR="$_PKGROOT/pkg" install -j"$_JOBS"
)

(
cd pkg/var/usr
rm -rf share lib/python*/test lib/python*/idlelib/idle_test
strip_and_sign "bin/$(readlink bin/python3)" lib/*.dylib lib/python3.*/lib-dynload/*.so
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/LICENSE "pkg/var/usr/share/licenses/$_PKGNAME"

builddeb
