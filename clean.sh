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

rm -r ./prebuilt
rm -r ./build

git submodule foreach --recursive git reset --hard
git submodule update --init --recursive

exit 0
