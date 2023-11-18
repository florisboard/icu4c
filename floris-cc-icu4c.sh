#!/usr/bin/env bash

# Copyright 2023 Patrick Goldinger
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Build script for ICU4C, tailored exactly for FlorisBoard's needs.

###### Build ICU4C ######

# Script params

icu_version_major=73
icu_version_minor=1
icu_libs=("uc" "tu" "i18n" "io" "data")
android_abi_list=("armeabi-v7a" "arm64-v8a" "x86" "x86_64")
android_api=24
desktop_target_list=(
    "x86_64-linux-gnu"
    "aarch64-linux-gnu"
    "x86_64-apple-darwin"
    "armv8a-apple-darwin"
)

# Script setup

cd "$(realpath "$(dirname "$0")")" || exit 1

if [[ -n "$ANDROID_HOME" ]]; then
    echo "[Android] Using SDK @ $ANDROID_HOME"
    llvm_toolchain="$ANDROID_HOME/ndk"
elif [[ -n "$ANDROID_SDK_ROOT" ]]; then
    echo "[Android] Using SDK @ $ANDROID_SDK_ROOT"
    llvm_toolchain="$ANDROID_SDK_ROOT/ndk"
else
    echo "[Android] Neither \$ANDROID_HOME nor \$ANDROID_SDK_ROOT is set, aborting!"
    exit 1
fi
llvm_toolchain=$(find "$llvm_toolchain" -mindepth 1 -maxdepth 1 -type d | sort -V | tail -n 1)
if [[ -n "$llvm_toolchain" ]]; then
    echo "[Android] Using NDK @ $llvm_toolchain"
else
    echo "[Android] Failed to find NDK installation from selected SDK, aborting!"
    exit 1
fi
llvm_toolchain="$llvm_toolchain/toolchains/llvm/prebuilt/linux-$(uname -m)"
if [[ -d "$llvm_toolchain" ]]; then
    echo "[Android] Using LLVM toolchain @ $llvm_toolchain"
else
    echo "[Android] Failed to find LLVM toolchain, aborting!"
    exit 1
fi

desktop_llvm_toolchain="$(realpath $(dirname $(realpath /usr/bin/clang))/..)"
if [[ -d "$desktop_llvm_toolchain" ]] && [[ -f "$desktop_llvm_toolchain/bin/llvm-ar" ]]; then
    echo "[Desktop] Using LLVM toolchain @ $desktop_llvm_toolchain"
else
    echo "[Desktop] Failed to find LLVM toolchain, aborting!"
    exit 1
fi

# Clean directories to guarantee a clean rebuild

echo "Removing $(realpath ./prebuilt)"
rm -rf ./prebuilt 2>/dev/null
echo "Removing $(realpath ./build)"
#rm -rf ./build 2>/dev/null

# Build for each ABI / Target

echo
mkdir -p "build"
cmake_log_file="build/cmake_build_log.txt"
for abi in "${android_abi_list[@]}"; do
    echo "Process target android/$abi"
    echo -n "  Configuring..."
    cmake -B=build -S=. \
        -DANDROID=1 \
        -DCMAKE_ANDROID_API=$android_api \
        -DCMAKE_ANDROID_ARCH_ABI=$abi \
        -DICU_DESKTOP_TARGET= \
        -DICU_BUILD_FROM_SOURCE=1 \
        -DICU_PREBUILT_TARGET=1 \
        -DLLVM_TOOLCHAIN="$llvm_toolchain" >> "$cmake_log_file" 2>&1
    if [ $? -eq 0 ]; then
        echo " completed"
    else
        echo " failed ($?)"
        continue
    fi
    echo -n "  Building..."
    cmake --build build >> "$cmake_log_file" 2>&1
    if [ $? -eq 0 ]; then
        echo "    completed"
    else
        echo "    failed ($?)"
    fi
done
for target in "${desktop_target_list[@]}"; do
    echo "Process target desktop/$target"
    echo -n "  Configuring..."
    cmake -B=build -S=. \
        -DANDROID=0 \
        -DCMAKE_ANDROID_API= \
        -DCMAKE_ANDROID_ARCH_ABI= \
        -DICU_DESKTOP_TARGET=$target \
        -DICU_BUILD_FROM_SOURCE=1 \
        -DICU_PREBUILT_TARGET=1 \
        -DLLVM_TOOLCHAIN="$desktop_llvm_toolchain" >> "$cmake_log_file" 2>&1
    if [ $? -eq 0 ]; then
        echo " completed"
    else
        echo " failed ($?)"
        continue
    fi
    echo -n "  Building..."
    cmake --build build >> "$cmake_log_file" 2>&1
    if [ $? -eq 0 ]; then
        echo "    completed"
    else
        echo "    failed ($?)"
    fi
done
echo "All targets processed. CMake build log available @ $(realpath $cmake_log_file)"

# Install to prebuilt directory

echo
prebuilt_target_dir="prebuilt/libs/android"
mkdir -p $prebuilt_target_dir
echo "Installing Android libs to $(realpath $prebuilt_target_dir)"
for abi in "${android_abi_list[@]}"; do
    mkdir -p $prebuilt_target_dir/$abi
    for icu_lib in "${icu_libs[@]}"; do
        cp build/src/android/$abi/lib/libicu${icu_lib}_floris.a \
            $prebuilt_target_dir/$abi/libicu${icu_lib}_floris.a
    done
done

prebuilt_target_dir="prebuilt/libs/desktop"
mkdir -p $prebuilt_target_dir
echo "Installing Desktop libs to $(realpath $prebuilt_target_dir)"
for target in "${desktop_target_list[@]}"; do
    mkdir -p $prebuilt_target_dir/$target
    for icu_lib in "${icu_libs[@]}"; do
        cp build/src/desktop/$target/lib/libicu${icu_lib}_floris.a \
            $prebuilt_target_dir/$target/libicu${icu_lib}_floris.a
    done
done

prebuilt_target_dir="prebuilt/assets/icu"
mkdir -p $prebuilt_target_dir
echo "Installing ICU data file to $(realpath $prebuilt_target_dir)"
mkdir -p $prebuilt_target_dir
cp build/src/host/share/icu_floris/$icu_version_major.$icu_version_minor/icudt${icu_version_major}l.dat \
    $prebuilt_target_dir/icudt${icu_version_major}l.dat

prebuilt_target_dir="prebuilt/include"
mkdir -p $prebuilt_target_dir
echo "Installing ICU header files to $(realpath $prebuilt_target_dir)"
mkdir -p $prebuilt_target_dir
cp -r build/src/host/include/* $prebuilt_target_dir

# Install to prebuilt directory

echo
echo "Script finished with exit code 0"
exit 0
