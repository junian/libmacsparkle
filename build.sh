#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="$ROOT_DIR/.build/release"
mkdir -p "$OUTPUT_DIR"

echo "Building MacSparkle for x86_64..."
cd "$ROOT_DIR"
swift build -c release --arch x86_64
cp ".build/x86_64-apple-macosx/release/libMacSparkle.dylib" "$OUTPUT_DIR/libMacSparkle-x86_64.dylib" 2>/dev/null || true

echo "Building MacSparkle for arm64..."
cd "$ROOT_DIR"
swift build -c release --arch arm64
cp ".build/arm64-apple-macosx/release/libMacSparkle.dylib" "$OUTPUT_DIR/libMacSparkle-arm64.dylib" 2>/dev/null || true

echo "Build artifacts written to $OUTPUT_DIR"
