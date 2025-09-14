#!/bin/sh
set -e
. ../../lib.sh

_get_distribution_components() {
    ninja -t targets | grep -Po 'install-\K.*(?=-stripped:)' | while read -r target; do
        case $target in
            llvm-libraries|distribution) continue ;;
            LLVM|LLVMgold|LLVMDemangle|LLVMSupport|LLVMTableGen|LLVMDebuginfod|LLVMTestingAnnotations|LLVMTestingSupport) ;;
            llvm-exegesis|LLVM*) continue ;;
        esac
        printf '%s;' "$target"
    done
}

(
mkdir -p src/build
cd src/build
tblgen="$(command -v llvm-tblgen)"
case $_CPU in
    (arm64*) ;;
    (arm*)
        # ld64 fails to link when built for thumb, so explicitly specify arm here
        export CFLAGS="-marm"
        export CXXFLAGS="$CFLAGS"
    ;;
esac
defaulttarget="$_CPU-apple-$_SUBSYSTEM$_SUBSYSTEMVER"

cmake -GNinja ../llvm \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DCMAKE_C_COMPILER="$_TARGET-cc" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DLLVM_ENABLE_THREADS=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DLLVM_NO_INSTALL_NAME_DIR_FOR_BUILD_TREE=ON \
    -DLLVM_DEFAULT_TARGET_TRIPLE="$defaulttarget" \
    -DLLVM_ENABLE_ZLIB=ON \
    -DLLVM_ENABLE_ZSTD=ON \
    -DLLVM_TARGETS_TO_BUILD='X86;ARM;AArch64' \
    -DLLVM_TABLEGEN="$tblgen" \
    -DLLVM_ENABLE_LTO=Thin \
    -DLLVM_ENABLE_LIBCXX=ON

cmake -GNinja ../llvm \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DCMAKE_C_COMPILER="$_TARGET-cc" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DLLVM_ENABLE_THREADS=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DLLVM_NO_INSTALL_NAME_DIR_FOR_BUILD_TREE=ON \
    -DLLVM_DEFAULT_TARGET_TRIPLE="$defaulttarget" \
    -DLLVM_ENABLE_ZLIB=ON \
    -DLLVM_ENABLE_ZSTD=ON \
    -DLLVM_TARGETS_TO_BUILD='X86;ARM;AArch64' \
    -DLLVM_TABLEGEN="$tblgen" \
    -DLLVM_ENABLE_LTO=Thin \
    -DLLVM_ENABLE_LIBCXX=ON \
    -DLLVM_DISTRIBUTION_COMPONENTS="$(_get_distribution_components)"

DESTDIR="$_PKGROOT/pkg" ninja -j"$_JOBS" install-distribution
)

(
cd pkg/var/usr
rm -rf share
for file in bin/* lib/*.dylib; do
    [ -h "$file" ] || strip_and_sign "$file"
done
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/llvm/LICENSE.TXT "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
