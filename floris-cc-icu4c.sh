#!/bin/bash

# Copyright 2021 Patrick Goldinger
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

# Before executing this script to manually rebuild the ICU libraries, make sure to execute
#  git submodule update --init --recursive
# else the script won't find the ICU source files!

###### Build ICU4C ######

cd "$(realpath "$(dirname "$0")")" || exit 1

# Clean prebuilt dir to guarantee a clean rebuild
rm -r ./prebuilt

bash src/android/cc-icu4c.sh build \
    --arch=arm,arm64,x86,x86_64 \
    --api=23 \
    --library-type=static \
    --build-dir=./build \
    --icu-src-dir=./src/android/icu/icu4c \
    --install-include-dir=./prebuilt/include \
    --install-libs-dir=./prebuilt/jniLibs \
    --install-data-dir=./prebuilt/assets/icu \
    --data-filter-file=./src/data-feature-filter.json \
    --data-packaging=archive \
    --enable-collation=no \
    --enable-formatting=no \
    --enable-legacy-converters=yes \
    --enable-regex=no \
    --enable-transliteration=no

exit $?
