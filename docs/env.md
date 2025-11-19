# Environment Configuration

The app reads compile-time configuration from Dart defines, which can be provided via
`--dart-define` pairs or through `--dart-define-from-file`. The `AppConfig` helper exposes the
values at runtime through `AppConfig.baseUrl`, `AppConfig.homeWebUrl`, and `AppConfig.useFakeAuth`.

## Provided `.env` files

The repository ships with example Dart define files under `env/`:

| File | Description |
| ---- | ----------- |
| `env/.env.local` | Defaults to a localhost API, enables fake auth, and points the Home tab to https://liven-sa.com/. |
| `env/.env.production` | Targets the production API (`https://liven-sa.com/api`), disables fake auth, and points the Home tab to https://liven-sa.com/. |
| `env/.env.example` | Template you can copy to create additional environment files. |

> **Note:** You can duplicate any of these files (e.g. `.env.staging`) and adjust the key/value pairs as needed.

## Running with a specific environment file

Use Flutter's `--dart-define-from-file` flag to inject the desired config file when running or building:

```bash
flutter run --dart-define-from-file=env/.env.local
```

For production (or any other file), point the flag at the corresponding path:

```bash
flutter build apk --dart-define-from-file=env/.env.production
```

If you only need to override one value temporarily, you can still fall back to explicit defines:

```bash
flutter run \
  --dart-define APP_BASE_URL=https://staging.example.com/api \
  --dart-define USE_FAKE_AUTH=false \
  --dart-define APP_HOME_WEB_URL=https://liven-sa.com/
```

When no value is supplied, `AppConfig` falls back to the defaults declared in
`lib/core/config/app_config.dart`.
