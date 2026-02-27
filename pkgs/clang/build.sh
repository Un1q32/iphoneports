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
mkdir -p "$_SRCDIR/build"
cd "$_SRCDIR/build"

llvmtblgen="$(command -v llvm-tblgen)"
ranlib="$(command -v "$_TARGET-ranlib")"
case $_CPU in
    (arm64*) ;;
    (arm*)
        # ld64 fails to link when built for thumb, so explicitly specify arm here
        cflags='-marm'
    ;;
esac
defaulttarget="$_CPU-apple-$_SUBSYSTEM$_SUBSYSTEMVER"

cmake -GNinja ../llvm \
    -DLLVM_ENABLE_PROJECTS='clang' \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
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
    -DLLVM_ENABLE_THREADS=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_TABLEGEN="$llvmtblgen" \
    -DLLVM_ENABLE_LTO=Thin \
    -DLLVM_ENABLE_LIBCXX=ON \
    -DLLVM_NO_INSTALL_NAME_DIR_FOR_BUILD_TREE=ON \
    -DLLVM_DEFAULT_TARGET_TRIPLE="$defaulttarget" \
    -DLLVM_TARGETS_TO_BUILD='X86;ARM;AArch64' \
    -DLLVM_ENABLE_ZLIB=ON \
    -DLLVM_ENABLE_ZSTD=ON \
    -DLLVM_BUILD_TOOLS=OFF \
    -DCROSS_TOOLCHAIN_FLAGS_NATIVE='-DCMAKE_C_COMPILER=clang;-DCMAKE_CXX_COMPILER=clang++'

cmake -GNinja ../llvm \
    -DLLVM_ENABLE_PROJECTS='clang' \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
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
    -DLLVM_ENABLE_THREADS=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_TABLEGEN="$llvmtblgen" \
    -DLLVM_ENABLE_LTO=Thin \
    -DLLVM_ENABLE_LIBCXX=ON \
    -DLLVM_NO_INSTALL_NAME_DIR_FOR_BUILD_TREE=ON \
    -DLLVM_DEFAULT_TARGET_TRIPLE="$defaulttarget" \
    -DLLVM_TARGETS_TO_BUILD='X86;ARM;AArch64' \
    -DLLVM_ENABLE_ZLIB=ON \
    -DLLVM_ENABLE_ZSTD=ON \
    -DLLVM_BUILD_TOOLS=OFF \
    -DCROSS_TOOLCHAIN_FLAGS_NATIVE='-DCMAKE_C_COMPILER=clang;-DCMAKE_CXX_COMPILER=clang++' \
    -DLLVM_DISTRIBUTION_COMPONENTS="$(_get_distribution_components)"

DESTDIR="$_DESTDIR" ninja install-distribution
)

(
cd "$_DESTDIR/var/usr"
rm -rf share bin/git-clang-format lib/libLLVM*
ln -s clang bin/cc
ln -s clang bin/gcc
ln -s clang++ bin/c++
ln -s clang++ bin/g++
for file in bin/* lib/*.dylib; do
    [ -h "$file" ] || strip_and_sign "$file"
done
)

installlicense "$_SRCDIR/clang/LICENSE.TXT"

builddeb
