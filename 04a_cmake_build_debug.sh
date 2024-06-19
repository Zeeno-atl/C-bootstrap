#!/bin/bash

set -e

cd build
cmake --build . --config Debug -j 1

