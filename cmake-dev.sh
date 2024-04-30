#!/bin/bash -eux

DIR=${1:-dev}
mkdir $DIR
cd $DIR

export CC=clang
export CXX=clang++

export CFLAGS='-no-canonical-prefixes -Os -gmlt -fno-omit-frame-pointer -fno-optimize-sibling-calls -fcolor-diagnostics'
export CXXFLAGS=$CFLAGS
#export LDFLAGS="-Wl,-rpath=$HOME/lib64 -Wl,-rpath=$HOME/lib"

cmake ../../llvm-project/llvm -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;cross-project-tests;lld;lldb" \
  -DLLVM_ENABLE_RUNTIMES="compiler-rt;libc;libcxx;libcxxabi;libunwind" \
  -DLIBCXX_ABI_UNSTABLE=ON \
  -DLLVM_CCACHE_BUILD=ON \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_ENABLE_LIBCXX=ON \
  -DLLVM_ENABLE_LLD=ON \
  -DLLVM_LIBDIR_SUFFIX=64
