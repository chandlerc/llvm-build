#!/bin/bash -eux

DIR=${1:-gcc-opt}
mkdir $DIR
cd $DIR

export CC=gcc
export CXX=g++

export CFLAGS='-O3 -DNDEBUG -march=native -fno-omit-frame-pointer'
export CXXFLAGS=$CFLAGS
export LDFLAGS="-Wl,-rpath=$HOME/lib64 -Wl,-rpath=$HOME/lib"

cmake ../../project/llvm -G Ninja \
  -DLLVM_ENABLE_PROJECTS="clang;lld;lldb;polly;libcxx;libcxxabi;compiler-rt;openmp;libunwind;parallel-libs" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_FLAGS_RELEASE= \
  -DCMAKE_CXX_FLAGS_RELEASE= \
  -DCMAKE_INSTALL_PREFIX=$HOME/installs/llvm-gcc-$(date +'%Y-%m-%d') \
  -DLIBCXX_ABI_UNSTABLE=ON \
  -DLLVM_CCACHE_BUILD=ON \
  -DLLVM_ENABLE_ASSERTIONS=OFF \
  -DLIBCXX_ENABLE_ASSERTIONS=OFF \
  -DLIBCXXABI_ENABLE_ASSERTIONS=OFF \
  -DLLVM_INCLUDE_GO_TESTS=OFF \
  -DLLVM_LIBDIR_SUFFIX=64
