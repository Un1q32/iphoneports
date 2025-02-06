#!/bin/sh -e

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

mkdir -p src/build
(
cd src/build || exit 1
tblgen="$(command -v "$_TARGET-sdkpath")"
tblgen="${tblgen%/*}/../share/iphoneports/bin/llvm-tblgen"
cmake -GNinja ../llvm -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_INSTALLNAMETOOL" -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DLLVM_ENABLE_THREADS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_ENABLE_LIBCXX=ON -DLLVM_LINK_LLVM_DYLIB=ON -DLLVM_NO_INSTALL_NAME_DIR_FOR_BUILD_TREE=ON -DLLVM_DEFAULT_TARGET_TRIPLE="$_TARGET" -DLLVM_ENABLE_ZLIB=ON -DLLVM_TARGETS_TO_BUILD='X86;ARM;AArch64' -DLLVM_TABLEGEN="$tblgen"
cmake -GNinja ../llvm -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_INSTALLNAMETOOL" -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DLLVM_ENABLE_THREADS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_ENABLE_LIBCXX=ON -DLLVM_LINK_LLVM_DYLIB=ON -DLLVM_NO_INSTALL_NAME_DIR_FOR_BUILD_TREE=ON -DLLVM_DEFAULT_TARGET_TRIPLE="$_TARGET" -DLLVM_ENABLE_ZLIB=ON -DLLVM_TARGETS_TO_BUILD='X86;ARM;AArch64' -DLLVM_TABLEGEN="$tblgen" -DLLVM_DISTRIBUTION_COMPONENTS="$(_get_distribution_components)"
DESTDIR="$_PKGROOT/pkg" ninja install-distribution -j"$_JOBS"
)

(
cd pkg/var/usr || exit 1
rm -rf share
for file in bin/* lib/*.dylib; do
  if ! [ -h "$file" ]; then
    "$_TARGET-strip" "$file" 2>/dev/null || true
    ldid -S"$_ENT" "$file"
  fi
done
)

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "llvm-$_DPKGARCH.deb"
