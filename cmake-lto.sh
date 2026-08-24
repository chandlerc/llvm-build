#!/bin/bash -eux

source "$(dirname "$0")/common.sh"
setup_build_dir "${1:-lto}"

export CC=clang
export CXX=clang++

export CFLAGS='-no-canonical-prefixes -O3 -DNDEBUG -march=native -gmlt -fno-omit-frame-pointer'
export CXXFLAGS=$CFLAGS
# LTO moves code generation into the link, so the optimization flags have to be
# repeated there to have any effect.
export LDFLAGS="-O3 -march=native -Wl,-rpath=\$ORIGIN/../lib -Wl,-rpath=$HOME/installs/llvm/lib"

cmake "$LLVM_SRC/llvm" -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;cross-project-tests;lld" \
  -DLLVM_ENABLE_RUNTIMES="compiler-rt;libcxx;libcxxabi;libunwind" \
  -DCMAKE_C_FLAGS_RELEASE= \
  -DCMAKE_CXX_FLAGS_RELEASE= \
  -DCMAKE_INSTALL_PREFIX=$HOME/installs/llvm-lto-$(date +'%Y-%m-%d') \
  -DCLANG_DEFAULT_CXX_STDLIB="libc++" \
  -DCLANG_DEFAULT_LINKER="lld" \
  -DCLANG_DEFAULT_OBJCOPY="llvm-objcopy" \
  -DCLANG_DEFAULT_RTLIB="compiler-rt" \
  -DCLANG_DEFAULT_UNWINDLIB="libunwind" \
  -DRUNTIMES_CMAKE_ARGS="$RUNTIMES_ARGS_RELEASE" \
  -DBUILTINS_CMAKE_ARGS="$BUILTINS_ARGS" \
  -DLLVM_CCACHE_BUILD=ON \
  -DLLVM_ENABLE_ASSERTIONS=OFF \
  -DLLVM_ENABLE_LIBCXX=ON \
  -DLLVM_ENABLE_LLD=ON \
  -DLLVM_ENABLE_LTO=ON
