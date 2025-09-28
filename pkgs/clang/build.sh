#!/bin/sh
set -e
. ../../files/lib.sh

_get_distribution_components() {
    ninja -t targets | grep -Po 'install-\K.*(?=-stripped:)' | while read -r target; do
        case $target in
            clang-repl|clang-libraries|distribution) continue ;;
            clang|clangd|clang-*) ;;
            clang*|findAllSymbols|scan-build*|scan-view|hmaptool) continue ;;
        esac
        printf '%s;' "$target"
    done
}

# awful hack to make clang not print git info in version string
mkdir -p "$_PKGROOT/src/iphoneports-fakebin"
printf '#!/bin/sh\nexit 1\n' > "$_PKGROOT/src/iphoneports-fakebin/git"
chmod +x "$_PKGROOT/src/iphoneports-fakebin/git"
export PATH="$_PKGROOT/src/iphoneports-fakebin:$PATH"

(
mkdir -p src/build
cd src/build
llvmtblgen="$(command -v llvm-tblgen)"
clangtblgen="$(command -v clang-tblgen)"
case $_CPU in
    (arm64*) ;;
    (arm*)
        # ld64 fails to link when built for thumb, so explicitly specify arm here
        export CFLAGS="-marm"
        export CXXFLAGS="$CFLAGS"
    ;;
esac

cmake -GNinja ../clang \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DCMAKE_C_COMPILER="$_TARGET-cc" \
    -DCMAKE_RANLIB="$(command -v "$_TARGET-ranlib")" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DCLANG_LINK_CLANG_DYLIB=ON \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_TABLEGEN_EXE="$llvmtblgen" \
    -DCLANG_TABLEGEN_EXE="$clangtblgen" \
    -DLLVM_ENABLE_LTO=Thin \
    -DLLVM_ENABLE_LIBCXX=ON

cmake -GNinja ../clang \
    -DCMAKE_BUILD_TYPE=MinSizeRel \
    -DCMAKE_C_COMPILER="$_TARGET-cc" \
    -DCMAKE_RANLIB="$(command -v "$_TARGET-ranlib")" \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_INSTALL_PREFIX=/var/usr \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH="$_SDK/var/usr" \
    -DCLANG_LINK_CLANG_DYLIB=ON \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_TABLEGEN_EXE="$llvmtblgen" \
    -DCLANG_TABLEGEN_EXE="$clangtblgen" \
    -DLLVM_ENABLE_LTO=Thin \
    -DLLVM_ENABLE_LIBCXX=ON \
    -DLLVM_DISTRIBUTION_COMPONENTS="$(_get_distribution_components)"

DESTDIR="$_PKGROOT/pkg" ninja -j"$_JOBS" install-distribution
)

(
cd pkg/var/usr
rm -rf share bin/git-clang-format
for link in clang++ clang-cl clang-cpp cc c++ gcc g++; do
    ln -sf clang "bin/$link"
done
for file in bin/* lib/*.dylib; do
    [ -h "$file" ] || strip_and_sign "$file"
done
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/clang/LICENSE.TXT "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
