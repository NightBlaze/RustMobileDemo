#!/usr/bin/env bash

if [ "$#" -ne 2 ]
then
    echo "Usage:"
    echo "build.sh <target> <build_variant>"
    exit 1
fi

# what to pass to cargo build -p, e.g. your_lib_ffi
FFI_TARGET=rustengine
# for what target to build (x86_64-apple-ios, aarch64-apple-ios, aarch64-apple-ios-sim)
TARGET=$1
# build_variant. can be "debug" or "release"
BUILDVARIANT=$2

OUT_HEADER=./header/rust_engine_header.h

if [[ "$TARGET" == "x86_64-apple-ios" ]]; then
  export CFLAGS_x86_64_apple_ios="-target x86_64-apple-ios"
fi

RELFLAG=
if [[ "$BUILDVARIANT" != "debug" ]]; then
  RELFLAG=--release
fi

export PATH="$HOME/.cargo/bin:$PATH"

set -euvx

cd ..

cbindgen --lang C --output $OUT_HEADER
cargo clippy
cargo build -p $FFI_TARGET --lib $RELFLAG --target $TARGET

cd -
