#!/bin/bash
# Build the G9910 (o1q) kernel with built-in KernelSU (backslashxx) and
# Hybrid Mount's VFS subsystem.  Samsung FASTUH/RKP/KDP, DEFEX and HDM are
# disabled in vendor/o1q_ksu_hybrid_defconfig.
set -e
cd "$(dirname "$0")"

export ARCH=arm64
export PATH="$PWD/toolchain/toolchains-gcc-10.3.0/bin:$PWD/toolchain/llvm-arm-toolchain-ship/10.0/bin:$PATH"
export LD_LIBRARY_PATH=/tmp/opencode/local/lib/x86_64-linux-gnu
export CROSS_COMPILE="$PWD/toolchain/toolchains-gcc-10.3.0/bin/aarch64-buildroot-linux-gnu-"
export REAL_CC="$PWD/toolchain/llvm-arm-toolchain-ship/10.0/bin/clang"
export LD="$PWD/toolchain/llvm-arm-toolchain-ship/10.0/bin/ld.lld"
export CLANG_TRIPLE=aarch64-linux-gnu-

COMMON=(
  ARCH=arm64
  CC="$REAL_CC" LD="$LD"
  AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump
  READELF=llvm-readelf STRIP=llvm-strip OBJSIZE=llvm-size
  CROSS_COMPILE="$CROSS_COMPILE" CLANG_TRIPLE="$CLANG_TRIPLE"
  LOCALVERSION=-2370012-abG9910ZCSGHZB1
  DTC_EXT="$PWD/tools/dtc" CONFIG_BUILD_ARM64_DT_OVERLAY=y
  CONFIG_SECTION_MISMATCH_WARN_ONLY=y
)

make -C "$PWD" O="$PWD/out" "${COMMON[@]}" vendor/o1q_ksu_hybrid_defconfig
make -C "$PWD" O="$PWD/out" "${COMMON[@]}" -j"$(nproc)"

cp out/arch/arm64/boot/Image arch/arm64/boot/Image
echo "Image: out/arch/arm64/boot/Image"
