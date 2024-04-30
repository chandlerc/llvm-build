#!/bin/bash -eux

DIR=${1:-opt}
mkdir $DIR
cd $DIR

export CC=clang
export CXX=clang++

export CFLAGS='-O3 -DNDEBUG -march=native'
export CXXFLAGS=$CFLAGS
export LDFLAGS="-Wl,-rpath=\$ORIGIN/../lib64 -Wl,-rpath=\$ORIGIN/../lib"

cmake ../../llvm-project/llvm -G Ninja \
  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lld;libcxx;libcxxabi;compiler-rt;openmp;libunwind" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_FLAGS_RELEASE= \
  -DCMAKE_CXX_FLAGS_RELEASE= \
  -DCMAKE_INSTALL_PREFIX=$HOME/installs/llvm-$(date +'%Y-%m-%d') \
  -DLIBCXX_ABI_UNSTABLE=ON \
  -DLLVM_CCACHE_BUILD=OFF \
  -DLLVM_ENABLE_ASSERTIONS=OFF \
  -DLIBCXX_ENABLE_ASSERTIONS=OFF \
  -DLIBCXXABI_ENABLE_ASSERTIONS=OFF \
  -DLLVM_ENABLE_LIBCXX=ON \
  -DLLVM_INCLUDE_GO_TESTS=OFF
