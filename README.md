# WindDown - Bedtime Ritual App

A gentle bedtime ritual app built with Kotlin + Jetpack Compose for Android.

## Features

- 🌙 **Landing Screen** - Animated moon with calming introduction
- ✅ **Reflection Screen** - Interactive calm checklist for bedtime routine
- 🧘 **Summary Screen** - Breathing animation and completion message
- ⚙️ **Settings** - Configure bedtime, trust mode, and calm list items
- 🔔 **Smart Notifications** - Daily bedtime reminders with exact alarm support
- 💾 **Local Storage** - Room database for persistent data
- 🏗️ **Modern Architecture** - MVVM + Hilt + Room + WorkManager

## Tech Stack

- **Language**: Kotlin
- **UI**: Jetpack Compose + Material 3
- **Architecture**: MVVM
- **Navigation**: Navigation Compose
- **Dependency Injection**: Hilt
- **Database**: Room
- **Background Tasks**: WorkManager + AlarmManager
- **Async**: Kotlin Coroutines + Flow

## Project Structure

```
app/
├── data/
│   ├── local/
│   │   ├── entity/         # Room entities
│   │   ├── dao/            # Room DAOs
│   │   └── WindDownDatabase.kt
│   └── repository/         # Data repository
├── di/                     # Hilt modules
├── navigation/             # Navigation setup
├── receiver/               # Broadcast receivers
├── ui/
│   ├── components/         # Reusable UI components
│   ├── screens/            # Screen composables
│   ├── state/              # UI state classes
│   ├── theme/              # Theme configuration
│   └── viewmodel/          # ViewModels
├── worker/                 # WorkManager workers
├── MainActivity.kt
└── WindDownApplication.kt
```

## Setup Instructions

### Prerequisites

- Android Studio Hedgehog (2023.1.1) or newer
- JDK 17
- Android SDK 34
- Gradle 8.2.2

### Installation

1. **Clone or download this project**

2. **Open in Android Studio**
   - File → Open → Select the WindDown folder

3. **Sync Gradle**
   - Android Studio should automatically sync
   - If not: File → Sync Project with Gradle Files

4. **Optional: Add Inter Font** (for exact design match)
   - Download Inter font from https://fonts.google.com/specimen/Inter
   - Add `Inter-Regular.ttf` and `Inter-Bold.ttf` to `app/src/main/res/font/`
   - Rename them to `inter_regular_ttf.ttf` and `inter_bold_ttf.ttf`
   - The app will work fine with system fonts if you skip this step

5. **Run the app**
   - Connect an Android device or start an emulator
   - Click the "Run" button or press Shift + F10

### Permissions

The app requests the following permissions:

- **POST_NOTIFICATIONS** (Android 13+) - For bedtime reminders
- **SCHEDULE_EXACT_ALARM** - For precise bedtime notifications
- **USE_EXACT_ALARM** - Alternative for exact alarms
- **WAKE_LOCK** - To ensure notifications work while device sleeps

## Key Features Explained

### Landing Screen
- Animated moon icon with pulsing effect
- Starry background animation
- "Begin WindDown" button to start the ritual

### Reflection Screen
- Editable calm checklist
- Glassmorphism card design
- Tap items to mark as complete
- Shows affirming message: "That's one less thing to carry tonight."
- Settings button to customize

### Summary Screen
- Shows completion time
- Breathing animation (inhale/exhale)
- Different message if revisiting same day
- Optional "WindDown Audio" button (placeholder for future feature)

### Settings
- **Bedtime Picker**: Set your preferred bedtime for notifications
- **Trust Mode**: Hide checklist to practice letting go
- **Calm List**: Add/remove custom reassuring items

### Notifications
- Daily reminder at your chosen bedtime
- Uses WorkManager for Android < 12
- Uses AlarmManager for Android 12+ (exact alarms)
- Tapping notification opens Reflection screen
- Automatically reschedules for next day

## Database Schema

### Settings Table
- `id`: Primary key (always 1)
- `bedtimeHour`: Hour (0-23)
- `bedtimeMinute`: Minute (0-59)
- `trustModeEnabled`: Boolean
- `completedToday`: Boolean
- `completionTime`: String (formatted time)
- `lastCompletionDate`: String (ISO date)

### CalmItems Table
- `id`: Auto-generated primary key
- `text`: Item description
- `order`: Display order
- `isChecked`: Boolean

## Customization

### Colors
Edit `app/src/main/java/com/winddown/app/ui/theme/Color.kt`:
- Primary: `#9D2BEE` (purple)
- Background: `#1A1022` to `#0C1445` (dark gradient)
- Text: `#E0DFFF` (light purple/white)

### Default Calm Items
Edit `WindDownRepository.kt` → `initializeDefaultItems()`:
```kotlin
val defaultItems = listOf(
    CalmItem(text = "Home feels safe.", order = 0),
    // Add your items here
)
```

### Notification Time
Default: 10:30 PM
Change in `Settings.kt` entity:
```kotlin
val bedtimeHour: Int = 22,  // 10 PM
val bedtimeMinute: Int = 30
```

## Troubleshooting

### Notifications not working
1. Check notification permissions in Settings
2. Ensure "Alarms & reminders" permission is granted (Android 12+)
3. Disable battery optimization for the app
4. Check that the app isn't force-stopped

### Build errors
1. Clean project: Build → Clean Project
2. Invalidate caches: File → Invalidate Caches / Restart
3. Check Gradle sync completed successfully
4. Verify JDK 17 is configured

### Database issues
- Uninstall and reinstall app to reset database
- Or use: Settings → Apps → WindDown → Storage → Clear Data

## Future Enhancements

- [ ] Audio meditation feature
- [ ] Weekly/monthly completion statistics
- [ ] Export/import calm list
- [ ] Dark/light theme toggle
- [ ] Widget for quick access
- [ ] Share calm items with friends
- [ ] Guided breathing exercises
- [ ] Sleep tracking integration

## License

This project is provided as-is for educational and personal use.

## Credits

- Design inspired by calming bedtime apps
- Built with modern Android best practices
- Uses Material 3 design system

---

**Note**: This app is designed to support healthy bedtime routines, not as medical advice. If you have serious sleep concerns or OCD, please consult with a healthcare professional.






