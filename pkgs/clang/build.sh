#!/bin/sh
. ../../files/lib.sh

_get_distribution_components() {
    ninja -t targets | grep -Po 'install-\K.*(?=-stripped:)' | while read -r target; do
        case $target in
            clang-repl|clang-libraries|llvm-*|distribution|LTO|Remarks|cmake-exports) continue ;;
            clang|clangd|clang-*|LLVM) ;;
            clang*|findAllSymbols|scan-build*|scan-view|hmaptool|LLVM*) continue ;;
        esac
        printf '%s;' "$target"
    done
}

# awful hack to make clang not print git info in version string
mkdir -p "$_SRCDIR/iphoneports-fakebin"
printf '#!/bin/sh\nexit 1\n' > "$_SRCDIR/iphoneports-fakebin/git"
chmod +x "$_SRCDIR/iphoneports-fakebin/git"
export PATH="$_SRCDIR/iphoneports-fakebin:$PATH"

(
mkdir -p "$_SRCDIR/build-native"
cd "$_SRCDIR/build-native"
cmake -GNinja ../llvm \
    -DLLVM_ENABLE_PROJECTS='clang' \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=hostcc \
    -DCMAKE_CXX_COMPILER=hostc++ \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_ENABLE_ZLIB=OFF \
    -DLLVM_ENABLE_ZSTD=OFF \
    -DLLVM_ENABLE_LIBXML2=OFF \
    -DCLANG_ENABLE_LIBXML2=OFF
ninja llvm-tblgen clang-tblgen
)

(
mkdir -p "$_SRCDIR/build"
cd "$_SRCDIR/build"

llvmtblgen="$_SRCDIR/build-native/bin/llvm-tblgen"
clangtblgen="$_SRCDIR/build-native/bin/clang-tblgen"
ranlib="$(command -v "$_TARGET-ranlib")"
case $_CPU in
    (arm64*) ;;
    (arm*)
        # ld64 fails to link when built for thumb, so explicitly specify arm here
        cflags='-marm'
    ;;
esac
lto=Thin
build=MinSizeRel
[ -n "$_DEBUG" ] && lto=OFF && build=Debug
cflags="$cflags -w"
defaulttarget="$_CPU-apple-$_SUBSYSTEM$_SUBSYSTEMVER"

cmake -GNinja ../clang \
    -DCMAKE_BUILD_TYPE="$build" \
    -DCMAKE_C_COMPILER="$_TARGET-cc" \
    -DCMAKE_C_FLAGS="$cflags" \
    -DCMAKE_CXX_FLAGS="$cflags" \
    -DCMAKE_RANLIB="$ranlib" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DCMAKE_SKIP_RPATH=ON \
    -DCLANG_LINK_CLANG_DYLIB=ON \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DLLVM_BUILD_UTILS=ON \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_TABLEGEN_EXE="$llvmtblgen" \
    -DCLANG_TABLEGEN="$clangtblgen" \
    -DLLVM_ENABLE_LTO="$lto" \
    -DLLVM_ENABLE_LIBCXX=ON \
    -DLLVM_DEFAULT_TARGET_TRIPLE="$defaulttarget" \
    -DHOST_LINK_VERSION=762

cmake -GNinja ../clang \
    -DCMAKE_BUILD_TYPE="$build" \
    -DCMAKE_C_COMPILER="$_TARGET-cc" \
    -DCMAKE_C_FLAGS="$cflags" \
    -DCMAKE_CXX_FLAGS="$cflags" \
    -DCMAKE_RANLIB="$ranlib" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DCMAKE_SKIP_RPATH=ON \
    -DCLANG_LINK_CLANG_DYLIB=ON \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DLLVM_BUILD_UTILS=ON \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_TABLEGEN_EXE="$llvmtblgen" \
    -DCLANG_TABLEGEN="$clangtblgen" \
    -DLLVM_ENABLE_LTO="$lto" \
    -DLLVM_ENABLE_LIBCXX=ON \
    -DLLVM_DEFAULT_TARGET_TRIPLE="$defaulttarget" \
    -DHOST_LINK_VERSION=762 \
    -DLLVM_DISTRIBUTION_COMPONENTS="$(_get_distribution_components)"

DESTDIR="$_DESTDIR" ninja install-distribution
)

(
cd "$_DESTDIR/var/usr"
rm -rf share bin/git-clang-format lib/libLLVM*
for link in clang++ clang-cl clang-cpp cpp cc c++ gcc g++; do
    ln -sf clang "bin/$link"
done
ln -sf offload-arch bin/amdgpu-arch
ln -sf offload-arch bin/nvptx-arch
for file in bin/* lib/*.dylib; do
    [ -h "$file" ] || strip_and_sign "$file"
done
)

installlicense "$_SRCDIR/clang/LICENSE.TXT"

builddeb
