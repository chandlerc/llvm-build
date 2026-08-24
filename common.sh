# Shared pieces of the cmake-*.sh configuration scripts in this directory.
#
# This file is sourced rather than run: each cmake-<config>.sh chooses its
# compiler and flags, and uses what is here for the parts that are the same in
# every configuration.

# The checkout to build. Set LLVM_SRC in the environment to build a different
# one. This can't be found relative to these scripts: the build directory is
# reached through a symlink (~/src/llvm/build -> /scratch/...), so "../.." from
# here lands next to the build trees rather than next to the checkout.
LLVM_SRC="${LLVM_SRC:-$HOME/src/llvm/llvm-project}"

# The llvm-test-suite checkout, used only by cmake-test-suite.sh.
TEST_SUITE_SRC="${TEST_SUITE_SRC:-$HOME/src/llvm/test-suite}"

# Configuration for the runtimes sub-build, passed as RUNTIMES_CMAKE_ARGS.
#
# The runtimes are built by the Clang that was just built, so they can use
# compiler-rt and the LLVM unwinder throughout. libc++abi and libunwind are
# linked into libc++.a but deliberately not into libc++.so, so that static
# links need nothing else while the shared library stays a single copy.
#
# Anything meant for the runtimes has to travel in here. LIBCXX_*, LIBCXXABI_*,
# LIBUNWIND_* and COMPILER_RT_* variables passed to the top-level CMake are
# silently ignored, because the runtimes are configured as a separate build.
#
# Do not add -DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=OFF. With it off the runtimes
# land in a flat <prefix>/lib that the driver never adds to its -L list, so
# CLANG_DEFAULT_UNWINDLIB=libunwind resolves -lunwind against the system
# libunwind and the resulting Clang can't link a C++ program at all.
RUNTIMES_ARGS_LIST=(
  -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON
  -DLIBCXX_STATICALLY_LINK_ABI_IN_SHARED_LIBRARY=OFF
  -DLIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY=ON
  -DLIBCXX_USE_COMPILER_RT=ON
  -DLIBCXX_HAS_ATOMIC_LIB=OFF
  -DLIBCXXABI_ENABLE_STATIC_UNWINDER=ON
  -DLIBCXXABI_STATICALLY_LINK_UNWINDER_IN_SHARED_LIBRARY=OFF
  -DLIBCXXABI_STATICALLY_LINK_UNWINDER_IN_STATIC_LIBRARY=ON
  -DLIBCXXABI_USE_COMPILER_RT=ON
  -DLIBCXXABI_USE_LLVM_UNWINDER=ON
  -DLIBUNWIND_USE_COMPILER_RT=ON
  -DCOMPILER_RT_USE_BUILTINS_LIBRARY=ON
  -DCOMPILER_RT_USE_LLVM_UNWINDER=ON
  -DSANITIZER_CXX_ABI=libc++
  -DSANITIZER_TEST_CXX=libc++
)

# CMake wants these as one semicolon-separated argument.
RUNTIMES_ARGS="$(IFS=';'; echo "${RUNTIMES_ARGS_LIST[*]}")"

# The same, for the configurations that install a toolchain: libc++abi enables
# its assertions by default regardless of build mode, so turn them off.
RUNTIMES_ARGS_RELEASE="$RUNTIMES_ARGS;-DLIBCXXABI_ENABLE_ASSERTIONS=OFF"

# Nothing here cross-compiles, so the builtins are built for the host only.
BUILTINS_ARGS="-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON"

# Create the build directory named by a script's first argument (or that
# configuration's default) and switch into it.
setup_build_dir() {
  mkdir -p "$1"
  cd "$1"
}
