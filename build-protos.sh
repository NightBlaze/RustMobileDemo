#!/bin/sh

PROTOS_DIR=./protos
OUT_IOS_PROTOS_DIR=./ios/RustMobileDemo/Protos
OUT_RUST_ENGINE_PROTOS_DIR=./rustengine/src/protos

echo "Cleaning..."
rm -drf $OUT_IOS_PROTOS_DIR
mkdir -p $OUT_IOS_PROTOS_DIR
rm -drf $OUT_RUST_ENGINE_PROTOS_DIR
mkdir -p $OUT_RUST_ENGINE_PROTOS_DIR

echo "Building swift files..."
protoc --proto_path=$PROTOS_DIR --swift_opt=FileNaming=DropPath --swift_out=$OUT_IOS_PROTOS_DIR ./$(find $PROTOS_DIR -iname "*.proto")

echo "Building rust files..."
protoc --proto_path=$PROTOS_DIR --rust_out=$OUT_RUST_ENGINE_PROTOS_DIR ./$(find $PROTOS_DIR -iname "*.proto")

echo "Done!"