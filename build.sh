#!/bin/sh
# Stop shellcheck from complaining about the find --version not specifying a path
# shellcheck disable=SC2185

# Uncomment to enable logging
# true > /tmp/buildsh.log
# exec 3>&1 4>&2
# trap 'exec 2>&4 1>&3' 0 1 2 3
# exec 1>/tmp/buildsh.log 2>&1

# If no arguments are specified, print usage info
if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    printf "Usage: build.sh <option> [--target=tripple] [--no-tmpfs] [-h, --help]
    <package name>          - Build a single package
    pkg <package name>      - Build a single package and add it to the repo
    all                     - Build all packages
    pkgall                  - Build all packages and add them to the repo
    clean                   - Clean a single package (remove build files)
    cleanall                - Clean all packages (remove build files)
    dryrun                  - Pretend to build all packages
    listpkgs                - List all packages
    --target                - Specify a target other than arm-apple-darwin9
    --no-tmpfs              - Do not use /tmp for anything (use if you have limited RAM)
    -h, --help              - Print this help message\n"

    if [ -z "$1" ]; then
        exit 1
    else
        exit 0
    fi
fi

# Error functions
_red=$(tput setaf 1)
_end=$(tput sgr0)
error() {
    printf "%sERROR:%s %s %s\n" "$_red" "$_end" "$1" "$2"
    exit 1
}

# Check target
case "$*" in
    *--target=*)
        _args="$*"
        _TARGET="${_args#*--target=}" ;;
    *)
        _TARGET="arm-apple-darwin9" ;;
esac

# Assign environment variables
# if $0 doesn't contain any slashes, assume it's in the current directory
if [ "${0%/*}" = "$0" ]; then
    _BSROOT="."
else
    _BSROOT="${0%/*}"
fi
_BSROOT="$(cd "$_BSROOT" && pwd)"
_PKGDIR="$_BSROOT/pkgs"
export _PKGDIR _BSROOT _TARGET
export TERM="xterm-256color"

# Decide where to put temporary files
case "$*" in
    *--no-tmpfs*)
        export _TMP="$_BSROOT" ;;
    *)
        export _TMP="/tmp" ;;
esac

# Cleanup temporary files from previous runs
true > "$_TMP/.builtpkgs"
rm -rf "$_TMP/sdk"
rm -rf "$_TMP/sdk.bak"

# Check for dependencies
depcheck() {
    for dep in "$_TARGET-clang" "$_TARGET-clang++" "$_TARGET-gcc" "$_TARGET-g++" "$_TARGET-cc" "$_TARGET-c++" "$_TARGET-strip" "$_TARGET-sdkpath" ldid dpkg-deb mv cp; do
        if ! command -v "$dep" > /dev/null; then
            error "Missing dependency:" "$dep"
        fi
    done

    # Check for Apple strip
    _strip_version=$("$_TARGET-strip" --version 2> /dev/null)
    case "$_strip_version" in
        *GNU*) error "GNU strip is not supported."
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

    # Check for GNU find
    if command -v gfind > /dev/null; then
        _FIND="gfind"
    elif command -v find > /dev/null; then
        _find_version="$(find --version)"
        case "$_find_version" in
            *GNU*) _FIND="find" ;;
            *) error "Non-GNU find detected. Please install GNU find." ;;
        esac
    else
        error "No find command detected. Please install GNU find."
    fi

    _SDK="$("$_TARGET-sdkpath")"
    export _MAKE _PATCH _FIND _SDK
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
    while read -r pkg; do
        if [ "$pkg" = "$1" ] && { [ -d "$_PKGDIR/$1/package" ] || [ "$2" = "dryrun" ]; }; then
            return 0
        fi
    done < "$_TMP/.builtpkgs"
    return 1
}

# Apply any patches found in the patches directory
# Unused durring dryruns
# This function is always run inside the package directory
applypatches() {
    if [ -d patches ]; then
        for patch in patches/*; do
            printf "Applying patch %s\n" "${patch##*/}"
            "$_PATCH" -p0 < "$patch"
        done
    fi
}

# Build an SDK for the build by copying the SDK at $_SDK to /tmp/sdk (or $_BSROOT/sdk if --no-tmpfs is specified) and then adding the /usr/include and /usr/lib directories from any dependencies
# We run hasbeenbuilt on each dependency to ensure that it has been built before we try to copy it
# When we do need to rebuild a dependency, we temporarily rename the sdk to sdk.bak, and then rename it back after we have rebuilt the dependency
# If this is a dryrun, we don't actually build the dependency, or copy the sdk
# If there is an sdk directory in the package folder, add it to the sdk. This allows us to add additional headers and libraries to the sdk per package
# First argument is dryrun to not actually build
includedeps() {
    if ! [ "$1" = "dryrun" ]; then
        if [ -d "$_SDK" ]; then
            export _SDKPATH="$_TMP/sdk"
            cp -ar "$_SDK" "$_SDKPATH"
        else
            error "SDK not found"
        fi
    fi

    if [ -f dependencies.txt ]; then
        while read -r dep; do
            if [ -d "$_PKGDIR/$dep" ]; then
                if ! hasbeenbuilt "$dep" "$1"; then
                    printf "Building dependency %s\n" "$dep"
                    [ "$1" = "dryrun" ] || mv "$_SDKPATH" "$_SDKPATH.bak"
                    build "$dep" "$1"
                    [ "$1" = "dryrun" ] || mv "$_SDKPATH.bak" "$_SDKPATH"
                fi
                printf "Including dependency %s\n" "$dep"
                if ! [ "$1" = "dryrun" ]; then
                    [ -d "$_PKGDIR/$dep/package/usr/include" ] && cp -ar "$_PKGDIR/$dep/package/usr/include" "$_SDKPATH/usr"
                    [ -d "$_PKGDIR/$dep/package/usr/lib" ] && cp -ar "$_PKGDIR/$dep/package/usr/lib" "$_SDKPATH/usr"
                fi
            else
                error "Dependency not found:" "$dep"
            fi
        done < dependencies.txt
    fi

    if ! [ "$1" = "dryrun" ]; then
        if [ -d sdk ]; then
            cp -ar sdk/* "$_SDKPATH"
        fi
    fi
}

# Parse arguments
if [ "$1" = "pkgall" ]; then
    depcheck
    buildall
    "$_FIND" . -iname "*.deb" -exec cp {} "$_BSROOT/debs" \;
elif [ "$1" = "all" ]; then
    depcheck
    buildall
elif [ "$1" = "listpkgs" ]; then
    for pkg in "$_PKGDIR"/*; do
        printf "%s\n" "${pkg##*/}"
    done
elif [ "$1" = "pkg" ]; then
    depcheck
    build "$2"
    "$_FIND" "$_PKGDIR/$2" -iname "*.deb" -exec cp {} "$_BSROOT/debs" \;
elif [ "$1" = "clean" ]; then
    rm -rf "$_PKGDIR/$2/package" "$_PKGDIR/$2/source"
elif [ "$1" = "cleanall" ]; then
    rm -rf "$_PKGDIR"/*/package "$_PKGDIR"/*/source
elif [ "$1" = "dryrun" ]; then
    buildall dryrun
elif [ -d "$_PKGDIR/$1" ]; then
    depcheck
    build "$1"
else
    error "Package not found:" "$1"
fi
