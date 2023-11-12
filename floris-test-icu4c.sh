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

# Test script for ICU4C

###### Build ICU4C ######

# Script params

test_files=("test_uinit")
build_dir="build/test"

# Script setup

cd "$(realpath "$(dirname "$0")")" || exit 1

# Execute tests

mkdir -p "$build_dir"
for test_file in "${test_files[@]}"; do
    /usr/bin/c++ "test/$test_file.cpp" \
        -o "$build_dir/$test_file.out" \
        -Ibuild/host/include \
        -Lbuild/host/lib \
        -licuuc_floris -licudata_floris
    ICU_DATA="prebuilt/assets/icu" ./$build_dir/$test_file.out
done
