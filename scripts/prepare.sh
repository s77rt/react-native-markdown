#!/bin/bash

git submodule update

emcc --no-entry -o wasm/parser/parser.mjs \
    -DMD4C_USE_UTF16 -fshort-wchar -Icpp/parser -Imd4c/src \
    -s STANDALONE_WASM \
    -s SINGLE_FILE=1 \
    -s WASM_ASYNC_COMPILATION=0 \
    -s ENVIRONMENT='web' \
    -s EXPORTED_FUNCTIONS='["_PARSEANDFORMAT", "_malloc", "_free"]' \
    -s EXPORTED_RUNTIME_METHODS='["stringToUTF16", "UTF16ToString"]' \
    -s TEXTDECODER=2 \
    -O3 \
    wasm/parser/parser-wasm.cpp cpp/parser/parser.cpp md4c/src/md4c.c
