# Zoom Video SDK configuration guide

This document explains how to configure the in-app Zoom experience that powers the **Join Zoom session** card on the home tab.

## 1. Create Zoom Video SDK credentials

1. Sign in to the [Zoom App Marketplace](https://marketplace.zoom.us/).
2. Create a **Video SDK** app (not an OAuth app) to obtain the **SDK Key** and **SDK Secret**.
3. Store the key/secret in your secure backend; they should never be shipped in the mobile binary.
4. Implement a lightweight token service that signs [Zoom Video SDK JWTs](https://developers.zoom.us/docs/video-sdk/auth/) with the secret. Expose the service behind HTTPS.

Example Node.js token endpoint:

```js
import jwt from 'jsonwebtoken';

const payload = {
  app_key: process.env.ZOOM_SDK_KEY,
  tpc: req.body.sessionName,
  role_type: 1,
  version: 1,
  iat: Math.round(Date.now() / 1000) - 30,
  exp: Math.round(Date.now() / 1000) + 3600,
};

const token = jwt.sign(payload, process.env.ZOOM_SDK_SECRET);
```

## 2. Provide runtime configuration

The Flutter layer reads credentials from `--dart-define` flags (or `.env` via `flutter run --dart-define-from-file`). Set at least the following when launching the app:

```bash
flutter run \
  --dart-define=ZOOM_SDK_DOMAIN=zoom.us \
  --dart-define=ZOOM_SESSION_NAME=my-demo-session \
  --dart-define=ZOOM_SESSION_USERNAME=Mobile+Tester \
  --dart-define=ZOOM_SESSION_TOKEN=YOUR_JWT \
  --dart-define=ZOOM_SESSION_PASSWORD=12345
```

Environment keys:

| Key | Description |
| --- | --- |
| `ZOOM_SDK_DOMAIN` | Zoom domain to connect to (`zoom.us` for production, `zoomgov.com` for Gov). |
| `ZOOM_SDK_ENABLE_LOGS` | Optional boolean (default `true`) to toggle native SDK logging. |
| `ZOOM_SDK_LOG_PREFIX` | Optional log file prefix. |
| `ZOOM_SESSION_NAME` | Human-friendly session/topic name shown to participants. |
| `ZOOM_SESSION_USERNAME` | Display name for the current user. |
| `ZOOM_SESSION_TOKEN` | JWT token signed on your backend using the SDK secret. |
| `ZOOM_SESSION_PASSWORD` | Optional passcode if the session requires it. |

## 3. Android configuration

Already included in this repo:

- `android/build.gradle.kts` pulls the Zoom Maven repository: `https://maven.zoom.us/maven2`.
- `android/app/build.gradle.kts` bumps the minSdk to **24** (Zoom Video SDK requirement).
- `android/app/src/main/AndroidManifest.xml` declares camera, microphone, Bluetooth, and audio permissions.

Extra steps to verify locally:

1. Ensure your `android/gradle.properties` has `android.enableDexingArtifactTransform=false` when using older Gradle versions.
2. If you use ProGuard/R8, add keep rules for `us.zoom.*` packages.
3. Sign release builds with your keystore; Zoom prevents installation on unsigned builds in some enterprise stores.

## 4. iOS configuration

The project already declares the required usage descriptions in `ios/Runner/Info.plist`:

- `NSCameraUsageDescription`
- `NSMicrophoneUsageDescription`
- `NSBluetoothAlwaysUsageDescription`

Additional reminders:

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Set your `TEAM_ID` under **Signing & Capabilities**.
3. Add the `ZoomVideoSDK` XCFramework via Swift Package Manager _only_ if you customize the native plugin; the Flutter plugin already links it.
4. When distributing through TestFlight, double-check that `NSPhotoLibraryAddUsageDescription` is included if you allow Zoom recordings (optional).

## 5. Testing the integration

1. Run `flutter run --dart-define=...` with a valid token.
2. From the home tab, tap **Join Zoom session**.
3. The Zoom Video SDK UI should appear; verify audio, video, and screen share permissions.
4. Use the backend token service to rotate tokens regularly (set the JWT `exp` to ~1 hour) to avoid `Invalid signature` errors.
5. Capture device logs when debugging:
   - Android: `adb logcat | grep ZoomVideoSDK`
   - iOS: Xcode > **View Device Logs**

## 6. Troubleshooting

| Symptom | Fix |
| --- | --- |
| `ZoomConfigurationException` on button tap | Missing `--dart-define` values. Confirm `ZOOM_SESSION_*` strings are non-empty. |
| `ZoomJoinException: errorCode=5` | JWT expired or signed with the wrong secret. Regenerate the token. |
| App crashes on launch (Android) | Ensure `minSdkVersion >= 24` and ABI filters include `arm64-v8a` and `armeabi-v7a`. |
| Black video preview | Confirm `android.permission.CAMERA` and `NSCameraUsageDescription` text exist and permissions are granted. |

Following these steps keeps the Flutter code clean—credentials stay outside the repository, and platform-specific requirements are documented for DevOps teams.
