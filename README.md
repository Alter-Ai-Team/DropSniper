# DropSniper

DropSniper is a privacy-first, serverless price tracker built with Flutter.

## Key Features
- 100% local storage with Hive.
- Project carts with hard budget thresholds.
- Product groups that support multi-store OR tracking and automatic cheapest-link selection.
- Background scraping every 6 hours via Workmanager.
- Local notifications when a cart total drops below budget.
- Native share intake (Android/iOS) for one-tap URL tracking.
- Cyberpunk dark UI with dashboard cards, budget rings, and 30-day sparkline history.

## CI/CD (GitHub Actions)
DropSniper now includes automated workflows:
- `.github/workflows/build.yml`:
  - Runs `flutter analyze` and `flutter test`.
  - Builds release Android APK on Ubuntu.
  - Builds release Windows desktop bundle on Windows.
  - Uploads build artifacts to the workflow run.
- `.github/workflows/release.yml`:
  - On tag push (`v*`), builds release APK and Windows bundle ZIP.
  - Publishes binaries to the corresponding GitHub Release.

## Run locally
```bash
flutter pub get
flutter run -d windows
# or
flutter run -d android
```

## Build locally
```bash
flutter build apk --release
flutter build windows --release
```

## Platform notes
- Android: share target intent filter is pre-configured in `android/app/src/main/AndroidManifest.xml`.
- iOS: background and notification capabilities are configured in `ios/Runner/Info.plist`.
