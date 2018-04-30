#!/bin/bash -eux

ARGS=$(getopt --longoptions="prefix:,cflags:,ldflags:,test,benchmark" -- "" "$@")
eval set -- "$ARGS"

PREFIX=opt
CFLAGS="-O3 -gmlt -fno-omit-frame-pointer"
LDFLAGS="-fuse-ld=lld"
BENCHMARK=false
while [[ $# -ge 1 ]]; do
  case "$1" in
    --)
      shift
      break
      ;;

    --prefix)
      PREFIX="$2"
      shift
      ;;

    --cflags)
      CFLAGS="$CFLAGS $2"
      shift
      ;;

    --ldflags)
      LDFLAGS="$LDFLAGS $2"
      shift
      ;;

    --test)
      BENCHMARK=false
      ;;

    --benchmark)
      BENCHMARK=true
      ;;
  esac
  shift
done

DIR=${1:-test-suite-$(basename "$PREFIX")}
mkdir $DIR
cd $DIR

if [[ $PREFIX != */* ]]; then
  PREFIX=../$PREFIX
fi
export CC=$PREFIX/bin/clang
export CXX=$PREFIX/bin/clang++

if $BENCHMARK; then
  SET_SUITE='-DTEST_SUITE_BENCHMARKING_ONLY=ON'
  SET_RUN_TYPE='-DTEST_SUITE_RUN_TYPE=ref'
else
  SET_SUITE='-DTEST_SUITE_BENCHMARKING_ONLY=OFF'
  SET_RUN_TYPE='-DTEST_SUITE_RUN_TYPE=test'
fi

export CFLAGS
export CXXFLAGS=$CFLAGS
export LDFLAGS="-Wl,-rpath=$PREFIX/lib64 -Wl,-rpath=$PREFIX/lib $LDFLAGS"

cmake ../../test-suite -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_FLAGS_RELEASE= \
  -DCMAKE_CXX_FLAGS_RELEASE= \
  -DTEST_SUITE_LIT=$PREFIX/bin/llvm-lit \
  -DTEST_SUITE_USE_PERF=ON \
  -DTEST_SUITE_SPEC2006_ROOT=$HOME/src/cpu2006 \
  $SET_SUITE \
  $SET_RUN_TYPE
