#!/bin/sh
# shellcheck disable=2086,2031,2030
set -e

if [ "$(uname -s)" = "Darwin" ]; then
    printf 'Toolchain not supported on Darwin\n'
    exit 1
fi

case $JOBS in
    ''|*[!0-9]*)
        if command -v nproc > /dev/null; then
            cpus=$(nproc)
        else
            cpus=$(sysctl -n hw.ncpu 2> /dev/null)
            [ -z "$cpus" ] && cpus=1
        fi

        JOBS=$((cpus * 2 / 3))
        [ "$JOBS" = 0 ] && JOBS=1
        export JOBS
    ;;
esac

if [ -z "$STRIP" ]; then
    if command -v llvm-strip > /dev/null 2>&1; then
        STRIP='llvm-strip'
    elif command -v strip > /dev/null 2>&1; then
        STRIP='strip'
    else
        STRIP='true'
    fi
fi

[ "${0%/*}" = "$0" ] && scriptroot="." || scriptroot="${0%/*}"
cd "$scriptroot" || exit 1
scriptroot="$PWD"
rm -rf build bin cctools-bin lib

if ! cc -dumpmachine > /dev/null 2>&1; then
    printf 'Toolchain requires cc to be gcc compatible\n'
    exit 1
fi
host="$(cc -dumpmachine)"

redundant_download() {
    tries=5
    while [ -z "$success" ] && [ "$tries" -gt 0 ]; do
        if curl -C - -# -L -O "$1"; then
            success=1
        else
            printf 'Failed to download file, tries remaining: %s\n' "$tries"
            tries=$((tries - 1))
        fi
    done
    if [ -z "$success" ]; then
        printf 'Failed to download rust sources after 5 tries\n'
        exit 1
    fi
    success=
}

(
mkdir "$scriptroot/build" && cd "$scriptroot/build"

printf "Building LLVM+Clang\n\n"
llvmver="22.1.8"
redundant_download "https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-$llvmver.tar.gz"
tar xzf "llvmorg-$llvmver.tar.gz"
mv "llvmorg-$llvmver.tar.gz" "../../dlcache/llvm-$llvmver.tar.gz"
mkdir "llvm-project-llvmorg-$llvmver/build"
(
cd "llvm-project-llvmorg-$llvmver"
for patch in "$scriptroot/buildsrc"/llvm-*.patch; do
    patch -p1 < "$patch"
done
cd build
export PATH="$scriptroot/buildsrc/llvmbin:$PATH"
command -v clang >/dev/null && command -v clang++ >/dev/null && cmakecc='-DCMAKE_C_COMPILER=clang' && cmakecpp='-DCMAKE_CXX_COMPILER=clang++' && lto='Thin'
[ "$(uname -s)" != "Darwin" ] && command -v ld.lld >/dev/null && lld=ON

llvm_components() {
    for component in \
    LLVM \
    LTO \
    clang \
    llvm-headers \
    clang-resource-headers \
    llvm-tblgen \
    dsymutil \
    llvm-config \
    llvm-objcopy \
    llvm-objdump \
    llvm-cov \
    llvm-nm \
    llvm-profdata \
    llvm-readobj \
    llvm-size \
    llvm-strip \
    llvm-ar \
    llvm-as \
    llvm-dis \
    llvm-link \
    llc \
    opt \
    ; do
        printf '%s;' "$component"
    done
}

cmake -GNinja ../llvm \
    -DCMAKE_BUILD_TYPE=Release \
    $cmakecc \
    $cmakecpp \
    -DLLVM_ENABLE_LLD="${lld:-OFF}" \
    -DLLVM_ENABLE_LTO="${lto:-OFF}" \
    -DCMAKE_INSTALL_PREFIX="$scriptroot" \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DCLANG_LINK_CLANG_DYLIB=OFF \
    -DLLVM_ENABLE_PROJECTS='clang' \
    -DLLVM_DISTRIBUTION_COMPONENTS="$(llvm_components)" \
    -DLLVM_TARGETS_TO_BUILD='X86;ARM;AArch64' \
    -DLLVM_DEFAULT_TARGET_TRIPLE="$host"
ninja -j"$JOBS" install-distribution
ninja -j"$JOBS" FileCheck
mv bin/FileCheck "$scriptroot/bin"
)
ln -s ../buildsrc/hostcc "$scriptroot/bin/hostcc"
ln -s ../buildsrc/hostcc "$scriptroot/bin/hostc++"

printf "Building libtapi\n\n"
tapiver="1600.0.11.8"
redundant_download "https://github.com/tpoechtrager/apple-libtapi/archive/refs/heads/$tapiver.tar.gz"
tar xzf "${tapiver}.tar.gz"
rm -f "${tapiver}.tar.gz"
(
cd "apple-libtapi-$tapiver"
INSTALLPREFIX="$scriptroot" \
    CC="$scriptroot/bin/hostcc" \
    CXX="$scriptroot/bin/hostc++" \
    NINJA=1 \
    ./build.sh
./install.sh
)

printf "Building cctools-port\n\n"
cctoolsver="1030.6.3-ld64-956.6"
redundant_download "https://github.com/Un1q32/cctools-port/archive/refs/heads/$cctoolsver.tar.gz"
tar xzf "${cctoolsver}.tar.gz"
rm -f "${cctoolsver}.tar.gz"
cp ../buildsrc/configure.h "cctools-port-$cctoolsver/cctools/ld64/src"
(
cd "cctools-port-$cctoolsver/cctools"
./configure \
    --prefix="$scriptroot" \
    --bindir="$scriptroot/cctools-bin" \
    --with-libtapi="$scriptroot" \
    --with-llvm-config="$scriptroot/bin/llvm-config" \
    --enable-silent-rules \
    CC="$scriptroot/bin/hostcc" \
    CXX="$scriptroot/bin/hostc++"
make -j"$JOBS"
make install
ln -s ../cctools-bin/lipo "$scriptroot/bin"
ln -s ../cctools-bin/otool "$scriptroot/bin"
ln -s ../cctools-bin/install_name_tool "$scriptroot/bin"
)
ln -s ../buildsrc/cc "$scriptroot/cctools-bin"
ln -s ../buildsrc/target-symlinks.sh "$scriptroot/bin"

printf "Building ldid\n\n"
ldidver="c50e84e18532044b23ec5e971d55ab0cdd4b6685"
redundant_download "https://github.com/ProcursusTeam/ldid/archive/${ldidver}.tar.gz"
tar xzf "${ldidver}.tar.gz"
rm -f "${ldidver}.tar.gz"
(
cd "ldid-$ldidver"
make CXX="$scriptroot/bin/hostc++"
"$STRIP" ldid
cp ldid "$scriptroot/bin"
)

printf "Building compiler-rt\n\n"
defaulttarget='armv6-apple-ios2'
if ! [ -d "../../sdks/$defaulttarget" ]; then
    nodefaultsdk=1
    mkdir "../../sdks/$defaulttarget"
fi
_DONT_REBUILD_TOOLCHAIN=1 _DONT_COPY_DEB=1 ../../build.sh --target=armv6-apple-ios2 compiler-rt
llvmshortver="$(cd "$scriptroot/lib/clang" && echo *)"
mkdir -p "$scriptroot/lib/clang/$llvmshortver/lib/darwin"
cp "../../pkgs/compiler-rt/pkg-$defaulttarget/var/usr/lib/clang/$llvmshortver/lib/darwin/"* "$scriptroot/lib/clang/$llvmshortver/lib/darwin"
if [ -n "$nodefaultsdk" ]; then
    rm -r "../../sdks/$defaulttarget"
fi

printf "Building rust\n\n"
rustver="1.97.1"
redundant_download "https://static.rust-lang.org/dist/rustc-${rustver}-src.tar.xz"
tar xJf "rustc-${rustver}-src.tar.xz"
rm -f "rustc-${rustver}-src.tar.xz"
(
case $host in
    (x86_64-*-linux-musl) rusthost=x86_64-unknown-linux-musl ;;
    (x86_64-*-linux-gnu) rusthost=x86_64-unknown-linux-gnu ;;
    (aarch64-*-linux-musl) rusthost=aarch64-unknown-linux-musl ;;
    (aarch64-*-linux-gnu|aarch64-*-linux) rusthost=aarch64-unknown-linux-gnu ;;
    (*)
        printf 'Host %s not supported for rust\n' "$host"
        exit 1
    ;;
esac
cd rustc-*/
sed -e "s|@PREFIX@|$scriptroot|g" \
    -e "s|@LLVMCONFIG@|$scriptroot/bin/llvm-config|g" \
    -e "s|@HOST@|$rusthost|g" "$scriptroot/buildsrc/bootstrap.toml" > bootstrap.toml
patch -p1 < "$scriptroot/buildsrc/rust-legacy-darwin.patch"
PATH="$scriptroot/bin:$PATH" \
    SDKROOT="$scriptroot/buildsrc/sysroot" \
    LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$scriptroot/lib" \
    CC=hostcc \
    AR=llvm-ar \
    BOOTSTRAP_SKIP_TARGET_SANITY=1 \
    ./x install -j "$JOBS"
ln -s "../../../$(readlink "$scriptroot/lib/libLLVM.so")" "$scriptroot/lib/rustlib/$rusthost/lib"
) || {
    printf 'Warning! this toolchain was built without rust support\n'
}
)

(
for bin in cctools-bin/*; do
    [ -h "$bin" ] || "$STRIP" "$bin"
done
rm -rf \
    include \
    share \
    etc \
    bin/llc \
    bin/opt \
    bin/llvm-link \
    bin/llvm-config \
    bin/llvm-objcopy \
    bin/llvm-size \
    bin/llvm-strip \
    bin/llvm-ar \
    bin/llvm-as \
    bin/llvm-readobj \
    bin/llvm-profdata \
    bin/llvm-objdump \
    bin/llvm-dis \
    bin/llvm-cov \
    bin/FileCheck \
    bin/rust-*
for bin in bin/* lib/*; do
    if [ ! -h "$bin" ] && [ -f "$bin" ]; then
        "$STRIP" "$bin"
    fi
done
)
cp toolchainver currenttoolchainver
rm -rf build
