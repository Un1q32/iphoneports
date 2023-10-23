# iPhonePorts build system

> Package build scripts for every package in iPhonePorts

## Usage

```
Usage: build.sh [options] <command>
    <pkg> [pkgs...]         - Build a single package
    all                     - Build all packages
    clean                   - Clean a single package
    cleanall                - Clean all packages
    dryrun                  - Pretend to build all packages
    --target                - Specify a target (default: armv7-apple-darwin11)
    --no-tmp                - Do not use /tmp for anything, use the current directory instead
    --no-deps               - Do not include dependencies
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
