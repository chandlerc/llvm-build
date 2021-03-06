#!/bin/bash -eux

DIR=${1:-dbg}
mkdir $DIR
cd $DIR

export CC=~/bin/clang
export CXX=~/bin/clang++

DEBUG_CFLAGS='-O0 -g -fno-omit-frame-pointer -fexperimental-new-pass-manager'
DEBUG_CXXFLAGS=$DEBUG_CFLAGS
export LDFLAGS="-Wl,-rpath=$HOME/lib64 -Wl,-rpath=$HOME/lib"

cmake ../../project/llvm -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DLLVM_ENABLE_PROJECTS="clang;lld;lldb;polly;libcxx;libcxxabi;compiler-rt;openmp;libunwind;parallel-libs" \
  -DCMAKE_C_FLAGS_DEBUG="$DEBUG_CFLAGS" \
  -DCMAKE_CXX_FLAGS_DEBUG="$DEBUG_CXXFLAGS" \
  -DLIBCXX_ABI_UNSTABLE=ON \
  -DLLVM_CCACHE_BUILD=ON \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_ENABLE_LIBCXX=ON \
  -DLLVM_ENABLE_LLD=ON \
  -DLLVM_INCLUDE_GO_TESTS=OFF \
  -DLLVM_LIBDIR_SUFFIX=64 \
  -DLLVM_USE_SPLIT_DWARF=ON
