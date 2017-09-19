#!/bin/bash -eux

DIR=${1:-test-suite}
mkdir $DIR
cd $DIR

PREFIX=${2:-opt}
if [[ $PREFIX != */* ]]; then
  PREFIX=../$PREFIX
fi
export CC=$PREFIX/bin/clang
export CXX=$PREFIX/bin/clang++

case ${3:-'test'} in
  'benchmark')
    SET_SUITE='-DTEST_SUITE_BENCHMARKING_ONLY=ON'
    SET_RUN_TYPE='-DTEST_SUITE_RUN_TYPE=ref'
    ;;
  'test')
    SET_SUITE='-DTEST_SUITE_BENCHMARKING_ONLY=OFF'
    SET_RUN_TYPE='-DTEST_SUITE_RUN_TYPE=test'
    ;;
  *)
    exit 1
    ;;
esac

CFLAGS=${4:-'-O3 -gmlt -fno-omit-frame-pointer'}
export CFLAGS
export CXXFLAGS=$CFLAGS
LDFLAGS=${5:-"-fuse-ld=lld -Wl,-rpath=$PREFIX/lib64 -Wl,-rpath=$PREFIX/lib"}
export LDFLAGS

cmake ../../test-suite -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_FLAGS_RELEASE= \
  -DCMAKE_CXX_FLAGS_RELEASE= \
  -DTEST_SUITE_LIT=$PREFIX/bin/llvm-lit \
  -DTEST_SUITE_USE_PERF=ON \
  -DTEST_SUITE_SPEC2006_ROOT=$HOME/src/cpu2006 \
  $SET_SUITE \
  $SET_RUN_TYPE
