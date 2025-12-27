# Quick Start Guide - WindDown Flutter App

## 🚀 Getting Started

### Step 1: Install Flutter

If you don't have Flutter installed:
```bash
# Check Flutter installation
flutter doctor
```

### Step 2: Navigate to Project

```bash
cd flutter_winddown
```

### Step 3: Get Dependencies

```bash
flutter pub get
```

### Step 4: Run the App

**For Android:**
```bash
flutter run
```

**For iOS (Mac only):**
```bash
flutter run
```

**For a specific device:**
```bash
flutter devices  # List available devices
flutter run -d <device-id>
```

## 📱 Building for Release

### Android APK

```bash
flutter build apk --release
```

The APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

### iOS (Mac only)

```bash
flutter build ios --release
```

Then open `ios/Runner.xcworkspace` in Xcode to build and archive.

## 🔧 Troubleshooting

### "Flutter command not found"
- Make sure Flutter is in your PATH
- Restart your terminal

### "No devices found"
- For Android: Enable USB debugging and connect device
- For iOS: Open Xcode and trust your Mac
- Or use an emulator/simulator

### Build errors
```bash
flutter clean
flutter pub get
flutter run
```

## 📋 Features Checklist

✅ Landing screen with animated moon  
✅ Reflection screen with calm list  
✅ Summary screen with breathing animation  
✅ Settings with time picker  
✅ Trust mode toggle  
✅ Daily bedtime notifications  
✅ Local data storage  

## 🎨 Design

- Deep navy background (#0A1022)
- Calming animations
- Material 3 design
- Dark mode optimized

Enjoy your peaceful WindDown! 🌙




