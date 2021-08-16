# icu4c
Build repository for FlorisBoard external dependency ICU4C

This repository contains all the tools needed for compiling ICU for FlorisBoard from source. Before executing the
build script, make sure to initialize all git submodules with `git submodule update --init --recursive`, then issue
`./floris-cc-icu4c.sh`. Building ICU requires you to be on an Linux machine with python3 installed.

For Google Play and GitHub releases this repository also contains locally pre-built library files to save on compile
time. If the build script is initialized, the new build fully replaces the existing pre-built files.
