#!/bin/sh
rm -rf pkg src
printf "Downloading source...\n"
mkdir src && cd src || exit 1
llvmver='19.1.7'
for project in llvm cmake; do
    {
    curl -L -s "https://github.com/llvm/llvm-project/releases/download/llvmorg-$llvmver/$project-$llvmver.src.tar.xz" | tar -xJ
    mv "$project-$llvmver.src" "$project"
    } &
done
wait
