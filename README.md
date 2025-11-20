# Liven

Production-ready Flutter starter focused on multilingual onboarding, Riverpod state management, and modular feature layers.

## Requirements

- Flutter 3.8 or newer
- Dart 3.8 or newer
- Xcode 15+ for iOS builds
- Android Studio / Android SDK 34+

## Getting Started

```bash
flutter pub get
flutter run
```

The project ships with Riverpod, GoRouter, localization stubs, and custom UI components so you can start wiring real features immediately.

## Environment configuration

Use the provided Dart define files under `env/` to toggle between fake and real auth implementations (or to change the API base URL).
See [`docs/env.md`](docs/env.md) for the list of available files and detailed run/build commands with `--dart-define-from-file`.

## Zoom Video SDK integration

Zoom calling is available directly from the home tab through the official `flutter_zoom_videosdk` plugin. All runtime credentials are pulled from `--dart-define` values, so no secrets are committed to the repo. Review [`docs/zoom_setup.md`](docs/zoom_setup.md) for:

- Required environment variables (`ZOOM_SESSION_*` and `ZOOM_SDK_*`).
- Android and iOS native configuration (permissions, Gradle repositories, plist keys).
- How to generate secure session tokens on the backend.
- Testing tips for the in-app "Join Zoom session" CTA.

## Push notifications

Review [`docs/notifications.md`](docs/notifications.md) for Firebase configuration, token sync logic, and how `FcmService` hooks into the auth flow and localized permission prompts.

## Localization

English and Arabic strings live inside `lib/l10n`. Run `flutter gen-l10n` to regenerate strongly typed accessors after editing the `.arb` files.

## Testing

```bash
flutter test
```

(Use `flutter test --coverage` to produce coverage reports.)
