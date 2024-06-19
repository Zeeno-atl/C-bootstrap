#!/bin/bash

set -e

cd build
CXX=clang++-18 cmake .. -G "Ninja" -DCMAKE_TOOLCHAIN_FILE="conan_toolchain.cmake" -DCMAKE_BUILD_TYPE=Debug

