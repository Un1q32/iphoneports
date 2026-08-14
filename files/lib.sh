#!/bin/sh

set -e

if [ -z "$_PKGNAME" ]; then
    printf 'Do not run this script directly, use the main build.sh\n'
    exit 1
fi

make() {
    command "$_MAKE" -j"$_JOBS" "$@"
}

ninja() {
    command ninja -j"$_JOBS" "$@"
}

realpath() {
    command "$_REALPATH" "$@"
}

strip_and_sign() {
    for file in "$@"; do
        magic=$(od -An -tx1 -j12 -N4 "$file" | tr -d ' \n')
        if [ "$magic" = "02000000" ]; then
            "$_TARGET-strip" -no_code_signature_warning "$file" # executable file
        else
            "$_TARGET-strip" -no_code_signature_warning -x "$file" # other, probably dylib
        fi
    done
    if { [ "$_SUBSYSTEM" != "macos" ] && [ "$_OSVER" -ge 20000 ]; } ||
        [ "$_CPU" = "arm64" ] || [ "$_CPU" = "arm64e" ] ||
        [ "$_ALWAYSSIGN" = 1 ]; then
        ldid -S"$_ENTITLEMENTS" "$@"
    fi
}

builddeb() {
    cp -r DEBIAN "$_DESTDIR"
    sed -e "s|@DPKGARCH@|$_DPKGARCH|" DEBIAN/control > "$_DESTDIR/DEBIAN/control"
    printf 'Pre-depends: iphoneports-base\n' >> "$_DESTDIR/DEBIAN/control"

    # SUID binaries must be moved outside of /var to work, except on rootless jailbreaks or macOS
    if [ "$_SUBSYSTEM" != 'macos' ] && [ -f "$_TMP/suidbinaries" ]; then
        cd "$_DESTDIR"
        if ! [ -f "$_DESTDIR/DEBIAN/postinst" ]; then
            printf '#!/var/usr/bin/sh\n' > "$_DESTDIR/DEBIAN/postinst"
            chmod +x "$_DESTDIR/DEBIAN/postinst"
        fi
        printf '/var/usr/bin/mkdir -p /usr/local/libexec/iphoneports 2>/dev/null || exit 0\n' >> "$_DESTDIR/DEBIAN/postinst"
        while IFS= read -r bin; do
            printf "/var/usr/bin/mv \"$bin\" /usr/local/libexec/iphoneports\n" >> "$_DESTDIR/DEBIAN/postinst"
            printf "/var/usr/bin/ln -s \"/usr/local/libexec/iphoneports/${bin##*/}\" \"$bin\"\n" >> "$_DESTDIR/DEBIAN/postinst"
        done < "$_TMP/suidbinaries"
        rm "$_TMP/suidbinaries"
        cd ..
    fi

    dpkg-deb -b --root-owner-group -Zgzip "$_DESTDIR" "$_PKGNAME-$_TRIPLE.deb"
}

installlicense() {
    mkdir -p "$_DESTDIR/var/usr/share/licenses/$_PKGNAME"
    cp "$@" "$_DESTDIR/var/usr/share/licenses/$_PKGNAME"
}

installsuid() {
    for bin in "$@"; do
        printf '/%s\n' "$(realpath --relative-to="$_DESTDIR" "$bin")" >> "$_TMP/suidbinaries"
    done
}
