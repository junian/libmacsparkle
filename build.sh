#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="$ROOT_DIR/.build/release"
mkdir -p "$OUTPUT_DIR"

X64_DYLIB="$ROOT_DIR/.build/x86_64-apple-macosx/release/libMacSparkle.dylib"
ARM64_DYLIB="$ROOT_DIR/.build/arm64-apple-macosx/release/libMacSparkle.dylib"
UNIVERSAL_DYLIB="$OUTPUT_DIR/libMacSparkle.dylib"

echo "Building MacSparkle for x86_64..."
swift build -c release --arch x86_64
cp "$X64_DYLIB" "$OUTPUT_DIR/libMacSparkle-x86_64.dylib" 2>/dev/null || true

echo "Building MacSparkle for arm64..."
swift build -c release --arch arm64
cp "$ARM64_DYLIB" "$OUTPUT_DIR/libMacSparkle-arm64.dylib" 2>/dev/null || true

echo "Creating universal dylib..."
lipo -create "$X64_DYLIB" "$ARM64_DYLIB" -output "$UNIVERSAL_DYLIB"

echo "Build artifacts written to $OUTPUT_DIR"
