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

## Run
```bash
flutter pub get
flutter run -d windows
```

## Platform notes
- Android: share target intent filter is pre-configured in `android/app/src/main/AndroidManifest.xml`.
- iOS: add background modes and URL handling in `ios/Runner/Info.plist`.
