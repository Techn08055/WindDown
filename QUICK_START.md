# WindDown - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Open in Android Studio

1. Launch **Android Studio Hedgehog (2023.1.1)** or newer
2. Click **File** → **Open**
3. Navigate to and select the **WindDown** folder
4. Click **OK**

### Step 2: Wait for Gradle Sync

Android Studio will automatically:
- Download required dependencies
- Configure the project
- Index files

**Wait for the sync to complete** (look at the bottom status bar)

### Step 3: Run the App

1. **Connect a device** or **start an emulator**
   - Minimum Android 8.0 (API 26)
   - Recommended: Android 12+ for best notification experience

2. Click the **green Run button** (▶) or press **Shift + F10**

3. Select your device/emulator

4. Wait for the app to install and launch

### Step 4: Grant Permissions

When the app launches, it will request:
- **Notification permission** (Android 13+)
- Tap **Allow** to receive bedtime reminders

### Step 5: Explore the App

1. **Landing Screen**: Tap "Begin WindDown"
2. **Reflection Screen**: 
   - Tap items to check them off
   - See the affirming message
   - Tap ⚙️ icon for Settings
3. **Settings**:
   - Set your bedtime
   - Toggle Trust Mode
   - Edit your calm list
4. **Complete the Day**: Tap "Close the Day"
5. **Summary Screen**: Watch the breathing animation

---

## 🎯 Testing Notifications

### Quick Test
1. Open Settings (⚙️ icon on Reflection screen)
2. Set bedtime to **2 minutes from now**
3. Tap "Done"
4. Wait 2 minutes
5. You should receive: "🌙 Ready to wind down?"
6. Tap the notification to open the app

### Android 12+ Setup
If notifications don't appear:
1. Go to phone **Settings**
2. **Apps** → **WindDown**
3. **Notifications** → Enable
4. **Alarms & reminders** → Enable (important!)
5. **Battery** → Unrestricted (recommended)

---

## 🏗️ Project Structure at a Glance

```
WindDown/
├── app/
│   ├── build.gradle.kts          ← Dependencies & configuration
│   └── src/main/
│       ├── AndroidManifest.xml   ← Permissions & components
│       ├── java/.../app/
│       │   ├── MainActivity.kt   ← Entry point
│       │   ├── data/             ← Room database & repository
│       │   ├── ui/               ← Compose screens & components
│       │   ├── worker/           ← Notifications
│       │   └── di/               ← Hilt modules
│       └── res/                  ← Resources (colors, strings, etc.)
├── build.gradle.kts              ← Root build file
└── README.md                     ← Full documentation
```

---

## ⚙️ Key Configuration Files

### Change App Colors
📁 `app/src/main/java/com/winddown/app/ui/theme/Color.kt`

```kotlin
val Primary = Color(0xFF9D2BEE)        // Change primary color
val BackgroundDark = Color(0xFF1A1022) // Change background
```

### Change Default Bedtime
📁 `app/src/main/java/com/winddown/app/data/local/entity/Settings.kt`

```kotlin
val bedtimeHour: Int = 22,    // Change to your preferred hour (0-23)
val bedtimeMinute: Int = 30   // Change to your preferred minute (0-59)
```

### Change Default Calm Items
📁 `app/src/main/java/com/winddown/app/data/repository/WindDownRepository.kt`

Find `initializeDefaultItems()` and edit:
```kotlin
val defaultItems = listOf(
    CalmItem(text = "Your custom item 1", order = 0),
    CalmItem(text = "Your custom item 2", order = 1),
    // Add more items...
)
```

---

## 🐛 Troubleshooting

### "Gradle sync failed"
```bash
# In terminal:
./gradlew clean
# Then: File → Invalidate Caches → Invalidate and Restart
```

### "Cannot resolve symbol 'R'"
- Wait for Gradle sync to complete
- Build → Clean Project
- Build → Rebuild Project

### Notifications not showing
1. ✅ Check notification permission granted
2. ✅ Check "Alarms & reminders" permission (Settings → Apps → WindDown)
3. ✅ Disable battery optimization for WindDown
4. ✅ Ensure app is not force-stopped
5. ✅ Try setting bedtime to 1-2 minutes from now for testing

### App crashes on launch
- Check Logcat in Android Studio (View → Tool Windows → Logcat)
- Look for error messages
- Ensure target device is API 26+

### Database errors
```bash
# Uninstall and reinstall to reset database:
adb uninstall com.winddown.app
./gradlew installDebug
```

---

## 📱 Device Compatibility

| Android Version | API Level | Status | Notes |
|----------------|-----------|--------|-------|
| Android 8.0    | 26        | ✅ Works | Minimum supported |
| Android 9      | 28        | ✅ Works | Full support |
| Android 10     | 29        | ✅ Works | Full support |
| Android 11     | 30        | ✅ Works | Full support |
| Android 12+    | 31+       | ✅ Works | Best experience (exact alarms) |
| Android 13+    | 33+       | ✅ Works | Runtime notification permission |

---

## 🎨 Design Match

The app matches the design in `stitch_landing_screen/`:

- ✅ **Landing**: Purple gradient, animated moon, "Begin WindDown" button
- ✅ **Reflection**: Glassmorphism cards, emoji header, settings icon
- ✅ **Settings**: Bottom sheet, time picker, trust mode toggle, calm list editor
- ✅ **Summary**: Breathing animation, completion message, different revisit message

---

## 🔧 Build Commands

```bash
# Debug build
./gradlew assembleDebug

# Release build (requires signing)
./gradlew assembleRelease

# Install debug on device
./gradlew installDebug

# Uninstall
adb uninstall com.winddown.app

# View logs
adb logcat | grep WindDown

# Clear app data (reset database)
adb shell pm clear com.winddown.app
```

---

## 📚 Learn More

- **Full Documentation**: See [README.md](README.md)
- **Project Structure**: See [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)
- **Android Docs**: https://developer.android.com/jetpack/compose
- **Material 3**: https://m3.material.io/

---

## ✅ Success Checklist

After setup, you should be able to:

- [x] App launches without errors
- [x] Navigate: Landing → Reflection → Summary
- [x] Open Settings dialog
- [x] Check/uncheck calm items
- [x] Add/delete calm items in settings
- [x] Set bedtime
- [x] Toggle trust mode
- [x] Complete the day (see summary with time)
- [x] Receive notification at bedtime
- [x] Tap notification opens app

---

## 🆘 Need Help?

1. **Check logs**: View → Tool Windows → Logcat
2. **Read error messages** in the Build output
3. **Review documentation**: README.md and PROJECT_STRUCTURE.md
4. **Clean rebuild**: Build → Clean Project, then Build → Rebuild Project

---

## 🎉 You're All Set!

The WindDown app is now ready to use. Enjoy your gentle bedtime ritual!

**Next steps**:
- Customize colors and calm items to your preference
- Test the notification system
- Share with friends who might benefit from mindful bedtime routines

---

**Built with ❤️ using Kotlin, Jetpack Compose, and modern Android architecture**






