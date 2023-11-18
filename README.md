# icu4c
Build repository for FlorisBoard external dependency ICU4C

This repository contains all the tools needed for compiling ICU4C for FlorisBoard from source.

To completely rebuild ICU4C and the `prebuilt` directory, issue `./floris-cc-icu4c.sh`. Building ICU requires you to be on an Linux machine with python3, clang and GNU make installed.

For Google Play and GitHub releases this repository also contains locally pre-built library files to save on compile time. If the build script is initialized, the new build fully replaces the existing pre-built files.

Additionally the `prebuilt` directory also contains prebuilt desktop libraries for some popular desktop architectures to save compile time for desktop tools.

TODO:
- Rework `src/data-feature-filter.json`, as it contains incorrect category names and some features may be too less/too much restricted.
- Add additional tests and make the test script more robust to unexpected machine states.
