# iPhonePorts build system

> Build scripts for the packages at https://cydia.uniq.gay/

## Setup

You will need an iPhonePorts toolchain to use the build scripts in this repo, you can build one with https://github.com/Un1q32/iphoneports-toolchain-build.

## Usage

```
Usage: build.sh [options] <command>
    <pkg> [pkgs...]         - Build specified packages
    build <pkg> [pkgs...]   - Build specified packages
    all [pkgs...]           - Build all packages (except those specified)
    clean <pkg> [pkgs...]   - Clean a single package
    cleanall                - Clean all packages
    dryrun [pkgs...]        - Pretend to build all packages, for debugging
    abibreak <pkg>          - ABI break helper, opens all the control files for packages
                              that depend on <pkg> and then rebuilds them
    --target                - Specify a target (default: armv6-apple-darwin10)
    --no-tmp                - Do not use /tmp for anything, use the current directory instead
```

## Examples

#### Build curl
```sh
./build.sh curl
```

#### Build ed and xxd
```sh
./build.sh ed xxd
```

#### Build gzip for arm64-apple-darwin14
```sh
./build.sh --target=arm64-apple-darwin14 gzip
```
