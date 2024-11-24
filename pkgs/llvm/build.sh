#!/bin/sh

_get_distribution_components() {
  ninja -t targets | grep -Po 'install-\K.*(?=-stripped:)' | while read -r target; do
    case $target in
      llvm-libraries|distribution)
        continue
        ;;
      LLVM|LLVMgold)
        ;;
      LLVMDemangle|LLVMSupport|LLVMTableGen)
        ;;
      LLVMDebuginfod)
        ;;
      LLVMTestingAnnotations|LLVMTestingSupport)
        ;;
      LLVM*)
        continue
        ;;
      llvm-exegesis)
        continue
        ;;
    esac
    printf '%s;' "$target"
  done
}

mkdir -p src/build
cp files/compat.c src/llvm/lib/Support
(
cd src/build || exit 1
cmake -GNinja ../llvm -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_INSTALLNAMETOOL" -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DLLVM_ENABLE_THREADS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_ENABLE_LIBCXX=ON -DLLVM_LINK_LLVM_DYLIB=ON -DLLVM_NO_INSTALL_NAME_DIR_FOR_BUILD_TREE=ON -DLLVM_DEFAULT_TARGET_TRIPLE="$_TARGET" -DLLVM_ENABLE_ZLIB=ON
cmake -GNinja ../llvm -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_INSTALLNAMETOOL" -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DLLVM_ENABLE_THREADS=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF -DLLVM_ENABLE_LIBCXX=ON -DLLVM_LINK_LLVM_DYLIB=ON -DLLVM_NO_INSTALL_NAME_DIR_FOR_BUILD_TREE=ON -DLLVM_DEFAULT_TARGET_TRIPLE="$_TARGET" -DLLVM_ENABLE_ZLIB=ON -DLLVM_DISTRIBUTION_COMPONENTS="$(_get_distribution_components)"
DESTDIR="$_PKGROOT/pkg" ninja install-distribution -j8
)

(
cd pkg/var/usr || exit 1
rm -rf share
for file in bin/* lib/*.dylib; do
  if ! [ -h "$file" ]; then
    "$_TARGET-strip" "$file" 2>/dev/null
    ldid -S"$_ENT" "$file"
  fi
done
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg llvm.deb
