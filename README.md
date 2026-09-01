# amanah

ISNA Halal Amanah — field certification & compliance app for halal auditors.
Flutter (Android + iOS). Package id `com.isnahalal.amanah`.

## Stack

Riverpod (manual DI) · go_router · Dio · Freezed · flutter_dotenv · very_good_analysis.
Architecture, design tokens, and milestones live in `../Docs & Resources/`.

## Environment

Only `env/.env.example` is committed. **After cloning, create your env files**
(they are gitignored):

```bash
cp env/.env.example env/.env.dev
cp env/.env.example env/.env.prod   # then set values in each
```

The flavor selects which one loads at build time — default is `dev`:

```bash
flutter run                            # loads env/.env.dev (mock data)
flutter run --dart-define=FLAVOR=prod  # loads env/.env.prod (real API)
```

Keys: `USE_MOCK_API` (true/false), `API_BASE_URL`. **Never put secrets here** —
runtime tokens go to secure storage; a real secret key belongs on the backend,
not in the app. `env/*` (except the template) and `*.p8/.pem/.p12` are gitignored.

## Common commands

```bash
flutter pub get              # install dependencies
flutter run                  # run on the selected device
flutter run -d chrome        # run in Chrome (quick UI check)
flutter devices              # list available devices
flutter analyze              # static analysis (must be clean)
dart format .                # format all Dart code
flutter test                 # run unit/widget tests
```

### Code generation (Freezed / json_serializable)

```bash
dart run build_runner build --delete-conflicting-outputs   # one-off
dart run build_runner watch  --delete-conflicting-outputs   # watch mode
```

### Builds

```bash
flutter build apk --debug    # debug APK (Android) with dev flavor that loads env/.env.dev
flutter build apk --release  # release APK (Android) with dev flavor that loads env/.env.dev
flutter build apk --release --dart-define=FLAVOR=prod  # release APK(Android) with prod flavor that loads env/.env.prod
flutter build appbundle      # Play Store bundle with dev flavor that loads env/.env.dev
flutter build appbundle --release  # Play Store bundle with prod flavor that loads env/.env.prod
flutter build appbundle --release --dart-define=FLAVOR=prod  # Play Store bundle with prod flavor that loads env/.env.prod
flutter build ios            # iOS (needs Xcode)
```

### Maintenance

```bash
flutter clean && flutter pub get   # reset build artifacts
flutter pub outdated               # check dependency updates
flutter doctor -v                  # verify toolchain
```

### ShoreBird

#### Builds
```bash
shorebird release --platforms=android,ios // This will build both Android(aab) and iOS(ipa)
shorebird release --platforms=android,ios -- --dart-define=FLAVOR=prod // Both platforms with prod flavor (env/.env.prod) for store upload
shorebird release android --artifact=apk // For Android APK
```
 
✅ Published Release 1.0.0+1!
Your next step is to upload the app bundle to the Play Store and App Store:
Android: /build/app/outputs/bundle/release/app-release.aab
iOS: build/ios/ipa

#### Patches
To create a patch for this release, run 
```bash
 shorebird patch --platforms=android --release-version=1.0.0+1 // For Android patch
 shorebird patch --platforms=ios --release-version=1.0.0+1 // For iOS patch
```

#### Preview / See Changes
```bash
shorebird preview --platforms=android,ios // This will preview both Android(aab) and iOS(ipa)
```



### Mock Data
```bash
flutter run --dart-define=FLAVOR=mock  # loads env/.env.mock (mock data)

Email: auditor@isnahalal.com
Password: password
OTP: 000000
```