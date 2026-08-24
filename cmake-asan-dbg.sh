#!/bin/bash -eux

source "$(dirname "$0")/common.sh"
setup_build_dir "${1:-asan-dbg}"

export CC=clang
export CXX=clang++

export CFLAGS='-no-canonical-prefixes -O0 -g -fcolor-diagnostics'
export CXXFLAGS=$CFLAGS
export LDFLAGS="-Wl,-rpath=\$ORIGIN/../lib -Wl,-rpath=$HOME/lib"

cmake "$LLVM_SRC/llvm" -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;cross-project-tests;lld" \
  -DLLVM_ENABLE_RUNTIMES="compiler-rt;libcxx;libcxxabi;libunwind" \
  -DRUNTIMES_CMAKE_ARGS="$RUNTIMES_ARGS" \
  -DBUILTINS_CMAKE_ARGS="$BUILTINS_ARGS" \
  -DLLVM_CCACHE_BUILD=ON \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_ENABLE_LIBCXX=ON \
  -DLLVM_ENABLE_LLD=ON \
  -DLLVM_USE_SANITIZER='Address;Undefined'
