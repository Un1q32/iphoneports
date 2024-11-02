#!/bin/sh
commit=aa37c11ad1a817248c9d1578ac99e133875b4eb5
rm -rf pkg src
printf "Downloading source...\n"
curl -L -s -o src.tar.gz https://github.com/swiftlang/llvm-project/archive/refs/heads/apple/stable/20210107.tar.gz
curl -L -s "https://github.com/tpoechtrager/apple-libtapi/archive/${commit}.tar.gz" | tar -xz &
printf "Unpacking source...\n"
tar -xf src.tar.gz
mv llvm-project-* src
wait
mv "apple-libtapi-${commit}/src/tapi" src/tapi
cp -a "apple-libtapi-${commit}/src/llvm" src
cp -a "apple-libtapi-${commit}/src/clang" src
rm -rf src.tar.gz "apple-libtapi-${commit}"
