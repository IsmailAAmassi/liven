# Push notification setup

This project ships with a single `FcmService` that wires Firebase Cloud Messaging into the Riverpod graph and keeps the auth flow updated with the latest device token.

## Firebase configuration

1. Run `flutterfire configure` (or create configs manually) to generate `google-services.json` and `GoogleService-Info.plist`.
2. Drop the Android file under `android/app/` and the iOS file under `ios/Runner/`.
3. Make sure the Google Services Gradle plugin remains applied in `android/app/build.gradle.kts` and the dependency is present in `android/build.gradle.kts`.
4. Enable the **Push Notifications** capability in the iOS Runner target and upload your APNs authentication key in the Firebase console.
5. Replace the placeholder values in `lib/firebase_options.dart` with the values emitted by `flutterfire configure`.

## Token flow

- `FcmService` requests notification permissions (after the custom localized dialog) and caches the device token inside `AuthStorage`.
- The auth view model sends the cached token with login and register requests.
- When Firebase refreshes the token, `FcmService` persists it locally and exposes a placeholder `updateBackendToken` method so the backend can be notified once the endpoint exists.

## Notification handling

- Foreground messages use `flutter_local_notifications` to display a native notification while the app is open.
- Background and terminated notifications rely on the top-level `firebaseMessagingBackgroundHandler` to initialize Firebase and trigger a local notification channel.
- Tapping any notification routes the user via GoRouter using the `route` key from the FCM payload (extend `_handleNotificationTap` in `App` for more complex navigation).

## Localization

All permission prompts and snackbars share the localized strings in `lib/l10n/app_*.arb`, so both Arabic and English users get a consistent messaging experience when opting into notifications or when they decline the permission.
