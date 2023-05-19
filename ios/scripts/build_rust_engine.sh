#!/usr/bin/env bash

if [ "$#" -ne 1 ]
then
    echo "Usage (note: only call inside xcode!):"
    echo "build_rust_engine.sh <engine_build_variant>"
    exit 1
fi

# engine_build_variant from our xcconfigs
BUILDVARIANT=$1

set -euvx

if [[ -n "${DEVELOPER_SDK_DIR:-}" ]]; then
  # Assume we're in Xcode, which means we're probably cross-compiling.
  # In this case, we need to add an extra library search path for build scripts and proc-macros,
  # which run on the host instead of the target.
  # (macOS Big Sur does not have linkable libraries in /usr/lib/.)
  export LIBRARY_PATH="${DEVELOPER_SDK_DIR}/MacOSX.sdk/usr/lib:${LIBRARY_PATH:-}"
fi

IS_SIMULATOR=0
if [ "${LLVM_TARGET_TRIPLE_SUFFIX-}" = "-simulator" ]; then
  IS_SIMULATOR=1
fi

cd ../rustengine/scripts

for arch in $ARCHS; do
  case "$arch" in
    x86_64)
      if [ $IS_SIMULATOR -eq 0 ]; then
        echo "Building for x86_64, but not a simulator build. What's going on?" >&2
        exit 2
      fi

      # Intel iOS simulator
      ./build.sh x86_64-apple-ios $BUILDVARIANT
      ;;

    arm64)
      if [ $IS_SIMULATOR -eq 0 ]; then
        # Hardware iOS targets
        ./build.sh aarch64-apple-ios $BUILDVARIANT
      else
        ./build.sh aarch64-apple-ios-sim $BUILDVARIANT
      fi
  esac
done

cd -
