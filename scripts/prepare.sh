#!/bin/bash

git submodule update

rm -rf wasm/parser/
mkdir -p wasm/parser/
emcc --no-entry -o wasm/parser/parser.wasm -DMD4C_USE_UTF16 -fshort-wchar -Imd4c/src -O3 cpp/parser/parser.cpp
