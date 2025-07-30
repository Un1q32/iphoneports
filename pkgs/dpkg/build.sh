#!/bin/sh
set -e
. ../../lib.sh
(
cd src
if ! command -v gtar >/dev/null; then
    mkdir tmpbin
    printf '%s' "\
#!/bin/sh
exec tar \"\$@\"
" > tmpbin/gtar
    chmod +x tmpbin/gtar
    export PATH="$PWD/tmpbin:$PATH"
fi
export TAR=gtar

for script in src/dpkg-maintscript-helper.sh src/dpkg-db-backup.sh src/dpkg-db-keeper.sh; do
    sed -i -e 's|^#!/bin/sh$|#!/var/usr/bin/sh|' "$script"
done
sed -i -e "s|@DPKGARCH@|$_DPKGARCH|g" data/tupletable

autoreconf -fi
./configure --host="$_TARGET" --prefix=/var/usr --with-admindir=/var/lib/dpkg --disable-start-stop-daemon --disable-dselect --with-deb-compressor=gzip CPPFLAGS='-Wno-incompatible-function-pointer-types' PERL=/usr/bin/perl
"$_MAKE" -j"$_JOBS"
"$_MAKE" DESTDIR="$_PKGROOT/pkg" install
)

(
cd pkg/var/usr
rm -rf share/man share/doc share/perl5 share/polkit-1 libexec/dpkg/methods ../lib/dpkg/methods
grep -Erl '#! ?/usr/bin/perl' | while IFS= read -r file; do
    rm -f "$file"
done
for bin in bin/*; do
    [ "$bin" = "bin/dpkg-maintscript-helper" ] && continue
    strip_and_sign "$bin"
done
)

mkdir -p "pkg/var/usr/share/licenses/$_PKGNAME"
cp src/COPYING "pkg/var/usr/share/licenses/$_PKGNAME"

cp -r DEBIAN pkg
sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > pkg/DEBIAN/control
dpkg-deb -b --root-owner-group -Zgzip pkg "$_PKGNAME.deb"
