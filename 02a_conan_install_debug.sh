#!/bin/bash

set -e

rm -rf build

source .venv/bin/activate

conan install . --output-folder=build --build=missing --settings build_type=Debug
