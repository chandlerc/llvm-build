#!/bin/bash -eux

DIR=${1:-opt}
mkdir $DIR
cd $DIR

export CC=~/bin/clang
export CXX=~/bin/clang++

export CFLAGS='-O3 -DNDEBUG -march=native -gmlt -fno-omit-frame-pointer'
export CXXFLAGS=$CFLAGS
export LDFLAGS="-Wl,-rpath=$HOME/lib64 -Wl,-rpath=$HOME/lib"

cmake ../.. -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_FLAGS_RELEASE= \
  -DCMAKE_CXX_FLAGS_RELEASE= \
  -DCMAKE_INSTALL_PREFIX=/home/chandlerc/installs/llvm-$(date +'%Y-%m-%d') \
  -DLIBCXX_ABI_UNSTABLE=ON \
  -DLLVM_CCACHE_BUILD=ON \
  -DLLVM_ENABLE_ASSERTIONS=OFF \
  -DLIBCXX_ENABLE_ASSERTIONS=OFF \
  -DLIBCXXABI_ENABLE_ASSERTIONS=OFF \
  -DLLVM_ENABLE_LLD=ON \
  -DLLVM_INCLUDE_GO_TESTS=OFF \
  -DLLVM_LIBDIR_SUFFIX=64
