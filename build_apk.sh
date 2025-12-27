#!/bin/bash

# WindDown App - APK Build Script
# This script builds the debug APK file

echo "======================================"
echo "  WindDown App - APK Builder"
echo "======================================"
echo ""

# Navigate to project directory
cd "$(dirname "$0")"

echo "📦 Building debug APK..."
echo ""

# Build the APK
./gradlew assembleDebug

# Check if build was successful
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ BUILD SUCCESSFUL!"
    echo ""
    echo "📱 APK Location:"
    echo "   app/build/outputs/apk/debug/app-debug.apk"
    echo ""
    echo "📊 APK Details:"
    ls -lh app/build/outputs/apk/debug/app-debug.apk 2>/dev/null || echo "   (APK will be created after first build)"
    echo ""
    echo "📤 To Install:"
    echo "   1. Transfer app-debug.apk to your Android device"
    echo "   2. Open the APK file on your device"
    echo "   3. Tap 'Install' (enable 'Unknown Sources' if needed)"
    echo ""
    echo "   OR use ADB:"
    echo "   adb install app/build/outputs/apk/debug/app-debug.apk"
    echo ""
else
    echo ""
    echo "❌ BUILD FAILED"
    echo ""
    echo "Common solutions:"
    echo "   1. Make sure Android SDK is installed"
    echo "   2. Run: ./gradlew clean"
    echo "   3. Open in Android Studio and let it sync first"
    echo ""
fi





