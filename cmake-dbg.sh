#!/bin/bash -eux

DIR=${1:-dbg}
mkdir $DIR
cd $DIR

export CC=~/bin/clang
export CXX=~/bin/clang++

export CFLAGS='-O0 -g -fno-omit-frame-pointer'
export CXXFLAGS=$CFLAGS
export LDFLAGS="-Wl,-rpath=$HOME/lib64 -Wl,-rpath=$HOME/lib"

cmake ../.. -G Ninja \
  -DCMAKE_C_FLAGS_DEBUG= \
  -DCMAKE_CXX_FLAGS_DEBUG= \
  -DLIBCXX_ABI_UNSTABLE=ON \
  -DLLVM_CCACHE_BUILD=ON \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_ENABLE_LIBCXX=ON \
  -DLLVM_ENABLE_LLD=ON \
  -DLLVM_INCLUDE_GO_TESTS=OFF \
  -DLLVM_LIBDIR_SUFFIX=64
