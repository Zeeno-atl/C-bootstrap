#!/bin/bash

set -e

python3 -m venv .venv
source .venv/bin/activate

pip install conan

if [ ! -f ~/.conan2/profiles/default ]; then
	conan profile detect
fi

# set C++ standard to 23
sed -i 's/compiler.cppstd=17/compiler.cppstd=23/g' ~/.conan2/profiles/default
sed -i 's/compiler.cppstd=gnu17/compiler.cppstd=23/g' ~/.conan2/profiles/default

# set compiler to clang-18
sed -i 's/compiler=gcc/compiler=clang/g' ~/.conan2/profiles/default
sed -i 's/compiler.version=14/compiler.version=18/g' ~/.conan2/profiles/default
