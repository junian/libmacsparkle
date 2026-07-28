#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="$ROOT_DIR/.build/universal/release"
mkdir -p "$OUTPUT_DIR"

# Extract version from Package.swift
VERSION=$(grep "let tag =" "$ROOT_DIR/Package.swift" | sed 's/.*"\(.*\)".*/\1/')
echo "Version: $VERSION"

X64_DYLIB="$ROOT_DIR/.build/x86_64-apple-macosx/release/libMacSparkle.dylib"
ARM64_DYLIB="$ROOT_DIR/.build/arm64-apple-macosx/release/libMacSparkle.dylib"
UNIVERSAL_DYLIB="$OUTPUT_DIR/libMacSparkle.dylib"

echo "Building MacSparkle for x86_64..."
swift build -c release --arch x86_64

echo "Building MacSparkle for arm64..."
swift build -c release --arch arm64

echo "Creating universal dylib..."
lipo -create "$X64_DYLIB" "$ARM64_DYLIB" -output "$UNIVERSAL_DYLIB"

echo "Copying Sparkle.framework..."
cp -R "$ROOT_DIR/.build/release/Sparkle.framework" "$OUTPUT_DIR/."

echo "Signing universal dylib..."
codesign --force --sign - "$UNIVERSAL_DYLIB"

# Package x64 dylib
X64_TEMP_DIR=$(mktemp -d)
cp "$X64_DYLIB" "$X64_TEMP_DIR/libMacSparkle.dylib"
cd "$X64_TEMP_DIR"
zip -q "$OUTPUT_DIR/libMacSparkle.v${VERSION}.x64.zip" libMacSparkle.dylib
cd "$ROOT_DIR"
rm -rf "$X64_TEMP_DIR"

# Package arm64 dylib
ARM64_TEMP_DIR=$(mktemp -d)
cp "$ARM64_DYLIB" "$ARM64_TEMP_DIR/libMacSparkle.dylib"
cd "$ARM64_TEMP_DIR"
zip -q "$OUTPUT_DIR/libMacSparkle.v${VERSION}.arm64.zip" libMacSparkle.dylib
cd "$ROOT_DIR"
rm -rf "$ARM64_TEMP_DIR"

# Package universal dylib
UNIVERSAL_TEMP_DIR=$(mktemp -d)
cp "$UNIVERSAL_DYLIB" "$UNIVERSAL_TEMP_DIR/libMacSparkle.dylib"
cd "$UNIVERSAL_TEMP_DIR"
zip -q "$OUTPUT_DIR/libMacSparkle.v${VERSION}.zip" libMacSparkle.dylib
cd "$ROOT_DIR"
rm -rf "$UNIVERSAL_TEMP_DIR"

echo "Build artifacts written to $OUTPUT_DIR"
echo "Created:"
echo "  - libMacSparkle.v${VERSION}.zip (universal)"
echo "  - libMacSparkle.v${VERSION}.arm64.zip (Apple Silicon)"
echo "  - libMacSparkle.v${VERSION}.x64.zip (Intel)"
