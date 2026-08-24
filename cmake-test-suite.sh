#!/bin/bash -eux

source "$(dirname "$0")/common.sh"

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

# A prefix without a slash names one of the build directories next to this
# script. Resolve it now, while the working directory is still predictable: it
# ends up in rpaths, where a relative path would be useless.
if [[ $PREFIX != */* ]]; then
  PREFIX="$(dirname "$0")/$PREFIX"
fi
PREFIX="$(cd "$PREFIX" && pwd)"

setup_build_dir "${1:-test-suite-$(basename "$PREFIX")}"

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

cmake "$TEST_SUITE_SRC" -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_C_FLAGS_RELEASE= \
  -DCMAKE_CXX_FLAGS_RELEASE= \
  -DTEST_SUITE_LIT=$PREFIX/bin/llvm-lit \
  -DTEST_SUITE_USE_PERF=ON \
  $SET_SUITE \
  $SET_RUN_TYPE
