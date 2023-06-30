#!/bin/sh
help() {
    printf "%s" "\
Usage: build.sh <command> [options]
    <pkg name>              - Build a single package
    build <pkg names>       - Build all specified packages
    all                     - Build all packages
    clean                   - Clean a single package (remove build files)
    cleanall                - Clean all packages (remove build files)
    dryrun                  - Pretend to build all packages
    list                    - List all packages
    --target                - Specify a target other than arm-apple-darwin9
    --no-tmpfs              - Do not use /tmp for anything (use if you have limited RAM)
    --help                  - Print this help message
"
}

case "$1" in
    -h|*help) help ; exit 0 ;;
esac

# Error function
error() {
    printf "\033[1;31mError:\033[0m %s %s\n" "$1" "$2"
    [ "$3" = "noexit" ] || exit 1
}

# Assign environment variables
# if $0 doesn't contain any slashes, assume it's in the current directory
[ "${0%/*}" = "$0" ] && _BSROOT="." || _BSROOT="${0%/*}"
cd "$_BSROOT" || exit 1
_BSROOT="$PWD"
_PKGDIR="$_BSROOT/packages"
TERM="xterm-256color"
export _PKGDIR _BSROOT
export TERM="xterm-256color"

if [ -z "$1" ]; then
    if [ -f "$_BSROOT/.args.txt" ]; then
        while read -r line; do
            set -- "$@" "$line"
        done < "$_BSROOT/.args.txt"
    else
        help
        exit 1
    fi
fi


# Decide where to put temporary files
case "$*" in
    *--no-tmpfs*) export _TMP="$_BSROOT" ;;
    *) export _TMP="/tmp" ;;
esac

# Check target
case "$*" in
    *--target=*) _TARGET="$*" ; _TARGET="${_TARGET#*--target=}" ; export _TARGET="${_TARGET%% *}" ;;
    *) export _TARGET="arm-apple-darwin9" ;;
esac

# Cleanup temporary files from previous runs
: > "$_TMP/.builtpkgs"
rm -rf "$_TMP"/sdk*

# Check for dependencies
depcheck() {
    for dep in "$_TARGET-clang" "$_TARGET-clang++" "$_TARGET-gcc" "$_TARGET-g++" "$_TARGET-cc" "$_TARGET-c++" "$_TARGET-strip" "$_TARGET-sdkpath" ldid dpkg-deb mv rm fakeroot od tr; do
        if ! command -v "$dep" > /dev/null; then
            error "Missing dependency:" "$dep"
        fi
    done

    # Check for Apple strip
    _strip_version=$("$_TARGET-strip" --version 2> /dev/null)
    case "$_strip_version" in
        *GNU*) error "GNU/LLVM strip is not supported."
    esac

    # Check for GNU make
    if command -v gmake > /dev/null; then
        _MAKE="gmake"
    elif command -v make > /dev/null; then
        _make_version="$(make --version)"
        case "$_make_version" in
            *GNU*) _MAKE="make" ;;
            *) error "Non-GNU make detected. Please install GNU make." ;;
        esac
    else
        error "No make command detected. Please install GNU make."
    fi

    # Check for GNU patch
    if command -v gpatch > /dev/null; then
        _PATCH="gpatch"
    elif command -v make > /dev/null; then
        _patch_version="$(patch --version)"
        case "$_patch_version" in
            *GNU*) _PATCH="patch" ;;
            *) error "Non-GNU patch detected. Please install GNU patch." ;;
        esac
    else
        error "No patch command detected. Please install GNU patch."
    fi

    # Check for GNU cp
    if command -v gcp > /dev/null; then
        _CP="gcp"
    elif command -v cp > /dev/null; then
        _cp_version="$(cp --version)"
        case "$_cp_version" in
            *GNU*) _CP="cp" ;;
            *) error "Non-GNU cp detected. Please install GNU cp." ;;
        esac
    else
        error "No cp command detected. Please install GNU cp."
    fi

    _SDK="$("$_TARGET-sdkpath")"
    export _MAKE _PATCH _SDK _CP
}

# Main build function
# First check if the package is already built, if it has then skip it
# Second cd to the package directory and export the _PKGROOT variable
# Third run the includedeps function to build/add any dependencies
# Fourth run the fetch.sh script to download the source code (skipped during dryrun)
# Fifth run the applypatches function to apply any patches to the source code (skipped during dryrun)
# Sixth run the build.sh script to build the package (skipped during dryrun)
# Lastly remove the temporary sdk directory
# First argument is the package name
# Second argument is dryrun to not actually build
build() {
    (
    if hasbeenbuilt "$1" "$2"; then
        exit 0
    fi
    cd "$_PKGDIR/$1" || exit 1
    export _PKGROOT="$_PKGDIR/$1"
    includedeps "$2"
    [ "$2" = "dryrun" ] || ./fetch.sh
    [ "$2" = "dryrun" ] || applypatches
    printf "Building %s\n" "$1"
    [ "$2" = "dryrun" ] || ./build.sh
    rm -rf "$_SDKPATH"
    printf "%s\n" "$1" >> "$_TMP/.builtpkgs"
    )
}

# Build all packages
buildall() {
    for pkg in "$_PKGDIR"/*; do
        build "${pkg##*/}" "$1"
    done
}

# Check if a required build dependency is missing
# If we need to rebuild then return 1
# Return 1 if $_PKGDIR/$1/package is missing
# if $2 = dryrun then we rebuild the first time this function is run, but not again until the next time the script is run, even if the package is missing
# First argument is the package name
# Second argument is dryrun to not actually build
hasbeenbuilt() {
    if [ "$2" = "dryrun" ]; then
        while read -r pkg; do
            if [ "$pkg" = "$1" ]; then
                return 0
            fi
        done < "$_TMP/.builtpkgs"
    elif [ -d "$_PKGDIR/$1/package" ]; then
        return 0
    fi
    return 1
}

# Apply any patches found in the patches directory
# Unused durring dryruns
# This function is always run inside the package directory
# This function does not take any arguments
applypatches() {
    if [ -d patches ]; then
        for patch in patches/*; do
            printf "Applying patch %s\n" "${patch##*/}"
            "$_PATCH" -p0 < "$patch"
        done
    fi
}

# Build an SDK for the build by copying the SDK at $_SDK to /tmp/sdk (or $_BSROOT/sdk if --no-tmpfs is specified) and then adding files from any dependencies
# We run hasbeenbuilt on each dependency to ensure that it has been built before we try to copy it
# When we do need to rebuild a dependency, we temporarily rename the sdk to sdk.$dep.bak, and then rename it back after we have rebuilt the dependency
# If this is a dryrun, we don't actually build the dependency, or copy the sdk
# If there is an sdk directory in the package folder, add it to the sdk. This allows us to add additional headers and stuff to the sdk if needed
# First argument is dryrun to not actually build
includedeps() {
    if ! [ "$1" = "dryrun" ]; then
        if [ -d "$_SDK" ]; then
            export _SDKPATH="$_TMP/sdk"
            "$_CP" -ar "$_SDK" "$_SDKPATH"
        else
            error "SDK not found"
        fi
    fi

    if [ -f dependencies.txt ]; then
        while read -r dep; do
            if [ -d "$_PKGDIR/$dep" ]; then
                if ! hasbeenbuilt "$dep" "$1"; then
                    printf "Building dependency %s\n" "$dep"
                    [ "$1" = "dryrun" ] || mv "$_SDKPATH" "$_SDKPATH.$dep.bak"
                    build "$dep" "$1"
                    [ "$1" = "dryrun" ] || mv "$_SDKPATH.$dep.bak" "$_SDKPATH"
                fi
                printf "Including dependency %s\n" "$dep"
                [ "$1" = "dryrun" ] || "$_CP" -ar "$_PKGDIR/$dep/package/"* "$_SDKPATH"
            else
                error "Dependency not found:" "$dep"
            fi
        done < dependencies.txt
    fi

    if ! [ "$1" = "dryrun" ]; then
        if [ -d sdk ]; then
            "$_CP" -ar sdk/* "$_SDKPATH"
        fi
    fi
}

# Parse arguments
if [ "$1" = "all" ]; then
    depcheck
    rm -rf "$_PKGDIR"/*/package "$_PKGDIR"/*/source
    buildall
    "$_CP" -fl "$_PKGDIR"/*/*.deb "$_BSROOT/debs" 2>/dev/null
elif [ "$1" = "list" ]; then
    for pkg in "$_PKGDIR"/*; do
        printf "%s\n" "${pkg##*/}"
    done
elif [ "$1" = "clean" ]; then
    rm -rf "$_PKGDIR/$2/package" "$_PKGDIR/$2/source" "$_PKGDIR/$2"/*.deb "$_BSROOT/debs/$2".deb
elif [ "$1" = "cleanall" ]; then
    rm -rf "$_PKGDIR"/*/package "$_PKGDIR"/*/source "$_PKGDIR"/*/*.deb "$_BSROOT"/debs/*.deb "$_TMP/sdk" "$_TMP/.builtpkgs" "$_BSROOT/sdk" "$_BSROOT/.builtpkgs"
elif [ "$1" = "dryrun" ]; then
    buildall dryrun
elif [ "$1" = "build" ]; then
    depcheck
    shift
    for pkg in "$@"; do
        [ -d "$_PKGDIR/$pkg" ] || error "Package not found:" "$pkg"
    done
    for pkg in "$@"; do
        rm -rf "$_PKGDIR/$pkg/package" "$_PKGDIR/$pkg/source"
    done
    for pkg in "$@"; do
        build "$pkg"
        "$_CP" -fl "$_PKGDIR/$pkg"/*.deb "$_BSROOT/debs" 2>/dev/null
    done
elif [ -d "$_PKGDIR/$1" ]; then
    depcheck
    rm -rf "$_PKGDIR/$1/package" "$_PKGDIR/$1/source"
    build "$1"
    "$_CP" -fl "$_PKGDIR/$1"/*.deb "$_BSROOT/debs" 2>/dev/null
else
    error "Package not found:" "$1"
fi
