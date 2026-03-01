#!/bin/bash

# Build script for Pomodori menu bar app

set -e

APP_NAME="Pomodori"
BUILD_DIR="build"
CONTENTS_DIR="$BUILD_DIR/$APP_NAME.app/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

echo "Building $APP_NAME..."

# Clean previous build
rm -rf "$BUILD_DIR"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"

# Compile iconset to icns
echo "Compiling app icon..."
ICONSET_DIR=$(mktemp -d)
cp -r "Pomodori/Assets.xcassets/AppIcon.appiconset" "$ICONSET_DIR/AppIcon.iconset"
iconutil -c icns -o "$RESOURCES_DIR/AppIcon.icns" "$ICONSET_DIR/AppIcon.iconset"
rm -rf "$ICONSET_DIR"

# Compile the Swift code
echo "Compiling app..."
swiftc \
    -o "$MACOS_DIR/$APP_NAME" \
    -framework Cocoa \
    Pomodori/main.swift

# Copy menu bar icons
cp Pomodori/tomato_menubar.png "$RESOURCES_DIR/" 2>/dev/null || true
cp Pomodori/tomato_menubar@2x.png "$RESOURCES_DIR/" 2>/dev/null || true

# Copy Info.plist
cp Pomodori/Info.plist "$CONTENTS_DIR/"

echo ""
echo "✓ Build complete!"
echo ""
echo "App location: $BUILD_DIR/$APP_NAME.app"
echo ""
echo "To run:"
echo "  open $BUILD_DIR/$APP_NAME.app"
echo ""
echo "To install to Applications:"
echo "  cp -r $BUILD_DIR/$APP_NAME.app /Applications/"
