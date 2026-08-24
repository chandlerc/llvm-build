#!/bin/bash -eux

source "$(dirname "$0")/common.sh"
setup_build_dir "${1:-dev}"

export CC=clang
export CXX=clang++

export CFLAGS='-no-canonical-prefixes -Os -gmlt -fno-omit-frame-pointer -fno-optimize-sibling-calls -fcolor-diagnostics'
export CXXFLAGS=$CFLAGS
export LDFLAGS="-L$(dirname $(which $CC))/../lib -static-libstdc++ -Wl,-rpath=\$ORIGIN/../lib -Wl,-rpath=$HOME/lib"

cmake "$LLVM_SRC/llvm" -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;cross-project-tests;lld;lldb;flang" \
  -DLLVM_ENABLE_RUNTIMES="compiler-rt;libcxx;libcxxabi;libunwind" \
  -DRUNTIMES_CMAKE_ARGS="$RUNTIMES_ARGS;-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON" \
  -DBUILTINS_CMAKE_ARGS="$BUILTINS_ARGS" \
  -DHAVE_UNW_ADD_DYNAMIC_FDE=ON \
  -DLLVM_CCACHE_BUILD=ON \
  -DLLVM_ENABLE_MODULES=OFF \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_ENABLE_LIBCXX=ON \
  -DLLVM_ENABLE_LLD=ON
