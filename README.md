# LA Status

Minimal iPhone app for showing custom text in **Live Activity** and **Dynamic Island** via Shortcuts.

<img width="240" src="assets/shortcut-example.png"> <img width="240" src="assets/dymanic-island-example.png"> <img width="240" src="assets/live-activity-on-lecked-screen.png">

## What it does

- Starts and updates a Live Activity with two labels:
  - Lock Screen / Live Activity label
  - Dynamic Island label
- Stops the Live Activity
- Works with **Shortcuts** via App Intents

## Requirements

- Xcode 15+
- iOS 17+
- Apple Developer team selected in Xcode
- Physical iPhone with Dynamic Island for Island UI (Live Activity on Lock Screen works on supported iPhones)

## Run the app

1. Copy `Local.xcconfig.example` to `Local.xcconfig` from the repository root:

   ```bash
   cp LAStatus/Config/Local.xcconfig.example \
      LAStatus/Config/Local.xcconfig
   ```

2. Set your own `PARENT_APP_BUNDLE_IDENTIFIER` in `LAStatus/Config/Local.xcconfig`.
3. Set your own `DEVELOPMENT_TEAM` in the same file.
4. If needed, set `APP_GROUP_IDENTIFIER` to an App Group enabled for your team.
5. Open `LAStatus/LAStatus.xcodeproj` in Xcode and build the app.
6. Add a 1024x1024 app icon in `LAStatus/Assets/AppIcon`.

After first launch, allow Live Activities if prompted.

## Shortcuts actions

The app provides two Shortcuts actions:

- **Show Live Activity** - start or update activity with both labels
- **Hide Live Activity** - end activity

## How to use with Shortcuts

1. Add action **Show Live Activity**.
2. Set Live Activity **Title**.
3. Set Dynamic Island **Label**.
4. Optional: set Dynamic Island Icon (SF Symbol) from [SF Symbols](https://developer.apple.com/sf-symbols/) and **Color**.
5. Run the shortcut.
6. When you’re done, use **Hide Live Activity**.

## Project structure

- `LAStatus` - app target
- `LAStatusWidgetExtension` - Live Activity UI for Lock Screen and Dynamic Island
- `LALiveActivityManager` - start / update / end logic
- `LAStatusStorage` - shared state via App Group `UserDefaults`
- `LAShortcutsIntents.swift` - Shortcuts/App Intents actions

## Default identifiers

- App bundle ID: `com.example.LAStatus` (an example, not guaranteed to be available for installation on a device; choose your own for a signed build).
- Widget bundle ID: derived automatically as `<PARENT_APP_BUNDLE_IDENTIFIER>.LAStatusWidget`.
- App Group: `group.com.example.LAStatus.shared` unless overridden in `Local.xcconfig`.

The widget bundle ID follows the app bundle ID automatically. Keep personal settings in the ignored `Local.xcconfig` file; do not change them in Xcode's Build Settings editor or commit that file.
