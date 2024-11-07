#!/bin/sh

_get_distribution_components() {
  ninja -t targets | grep -Po 'install-\K.*(?=-stripped:)' | while read -r target; do
    case $target in
      clang-libraries|distribution)
        continue
        ;;
      clang|clangd|clang-*)
        ;;
      clang*|findAllSymbols|scan-build*|scan-view|hmaptool)
        continue
        ;;
    esac
    echo "$target"
  done
}

# awful hack to make clang not print git info in version string
mkdir -p "$_TMP/iphoneports-fakebin"
printf '#!/bin/sh\nexit 1\n' > "$_TMP/iphoneports-fakebin/git"
chmod +x "$_TMP/iphoneports-fakebin/git"
export PATH="$_TMP/iphoneports-fakebin:$PATH"

mkdir -p src/build
(
cd src/build || exit 1
cmake -GNinja ../clang -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_INSTALLNAMETOOL" -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DCLANG_LINK_CLANG_DYLIB=ON -DLLVM_LINK_LLVM_DYLIB=ON -DLLVM_INCLUDE_TESTS=OFF -DLLVM_TABLEGEN_EXE="$(command -v llvm-tblgen)"
cmake -GNinja ../clang -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$_TARGET-cc" -DCMAKE_SYSTEM_NAME=Darwin -DCMAKE_INSTALL_PREFIX=/var/usr -DCMAKE_INSTALL_NAME_TOOL="$_INSTALLNAMETOOL" -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" -DCLANG_LINK_CLANG_DYLIB=ON -DLLVM_LINK_LLVM_DYLIB=ON -DLLVM_INCLUDE_TESTS=OFF -DLLVM_TABLEGEN_EXE="$(command -v llvm-tblgen)" -DLLVM_DISTRIBUTION_COMPONENTS="$(_get_distribution_components | paste -sd ';')"
DESTDIR="$_PKGROOT/pkg" ninja install-distribution -j8
)

rm -rf "$_TMP/iphoneports-fakebin"

(
cd pkg/var/usr || exit 1
rm -rf share bin/git-clang-format
for file in bin/* lib/*.dylib; do
  if ! [ -h "$file" ]; then
    "$_TARGET-strip" "$file" 2>/dev/null
    ldid -S"$_ENT" "$file"
  fi
done
)

cp -r DEBIAN pkg
dpkg-deb -b --root-owner-group -Zgzip pkg clang.deb
