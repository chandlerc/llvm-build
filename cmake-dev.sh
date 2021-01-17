#!/bin/bash -eux

DIR=${1:-dev}
mkdir $DIR
cd $DIR

export CC=~/bin/clang
export CXX=~/bin/clang++

export CFLAGS='-O2 -gmlt -fexperimental-new-pass-manager -fno-omit-frame-pointer -fno-optimize-sibling-calls -Xclang -mdisable-tail-calls'
export CXXFLAGS=$CFLAGS
export LDFLAGS="-Wl,-rpath=$HOME/lib64 -Wl,-rpath=$HOME/lib"

cmake ../../llvm-project/llvm -G Ninja \
  -DLLVM_ENABLE_PROJECTS="clang;lld;lldb;polly;libcxx;libcxxabi;compiler-rt;openmp;libunwind;parallel-libs" \
  -DCMAKE_C_FLAGS_DEBUG= \
  -DCMAKE_CXX_FLAGS_DEBUG= \
  -DLIBCXX_ABI_UNSTABLE=ON \
  -DLLVM_CCACHE_BUILD=ON \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_ENABLE_LIBCXX=ON \
  -DLLVM_ENABLE_LLD=ON \
  -DLLVM_INCLUDE_GO_TESTS=OFF
