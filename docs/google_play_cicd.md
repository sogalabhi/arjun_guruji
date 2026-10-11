# CI/CD Pipeline: Google Play Store Release

This document describes the CI/CD pipeline for the **Arjun Guruji** Flutter application, which builds, validates and uploads release builds to Google Play as a **draft** release.

## Pipeline Overview

Implemented as a GitHub Actions workflow: [.github/workflows/play-internal-testing.yml](../.github/workflows/play-internal-testing.yml).

| | |
|---|---|
| **Triggers** | Push of a `v*` tag, or manual `workflow_dispatch` from the Actions tab |
| **Package** | `org.snsds.arjunguruji` |
| **Track** | Tag push: `internal`. Manual run: `internal`, `alpha` (closed), `beta` (open) or `production` |
| **Release status** | `draft` (promote/roll out manually in Play Console) |
| **Jobs** | `build` (build + checks + artifacts) then `deploy` (upload to Play) |

`build` and `deploy` are separate so that an upload failure (Play API permissions, service account, etc.) can be fixed by re-running only the failed `deploy` job from GitHub's "Re-run failed jobs" without rebuilding the app.

---

## Releasing

1. Bump `version:` in `pubspec.yaml` (e.g. `2.2.4+21`) and merge to `main`.
2. Either:
   - **Tag:** `git tag v2.2.4 && git push origin v2.2.4`. The tag must equal the pubspec version name or the build fails. The build number is taken from pubspec (`+21`).
   - **Manual:** run the workflow, pick the track and optionally add release notes. `usePubspecBuildNumber` defaults to `true`; set it to `false` to use `run number + buildOffset` instead.

---

## Workflow Steps (`build` job)

1. **Checkout & environment**: Java 17 (Temurin) and Flutter `3.47.x` (match the SDK used locally).
2. **Caches**: Pub packages and Gradle caches/wrapper.
3. **Signing**: decodes `KEYSTORE_FILE` to `android/app/release.keystore` and writes `android/key.properties` from secrets.
4. **Gradle tuning**: appends `org.gradle.caching` and `org.gradle.parallel` to `android/gradle.properties` (CI only).
5. **Quality gates**
   - `flutter analyze --no-fatal-infos --no-fatal-warnings`: only analyzer **errors** fail the build.
   - `flutter test`: runs when a `test/` directory exists, skipped otherwise.
6. **Build**: `flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols`.
7. **Validation**
   - Confirms the `.aab` exists.
   - **16KB page-size check**: scans `arm64-v8a` and `x86_64` `.so` files with `objdump`; fails on any 4KB (`2**12`) alignment, if a library can't be read, or if no 64-bit libraries are found. 32-bit ABIs are intentionally skipped (not subject to the 16KB requirement).
8. **Artifacts**: uploads the `.aab` (30 days) and the Dart debug symbols (90 days). Keep the symbols: obfuscated crash traces can't be decoded without them.
9. **Cleanup** (always): removes the keystore and `key.properties` from the runner.

The `deploy` job downloads the `.aab` artifact and uploads it to Play with the service account (release notes become `whatsnew-en-US` when provided).

---

## Required GitHub Secrets

Set in `Settings > Secrets and variables > Actions`:

| Secret Name | Description |
|-------------|-------------|
| `KEYSTORE_FILE` | Base64 of the release/upload keystore: `base64 -w 0 android/app/release.keystore` |
| `KEYSTORE_PASSWORD` | Keystore (store) password |
| `KEY_ALIAS` | Key alias |
| `KEY_PASSWORD` | Key password |
| `SERVICE_ACCOUNT_JSON` | Full contents of the Google Play service account JSON key |

Never commit these files. `key.properties`, `*.keystore` and `*.jks` are ignored by `android/.gitignore`; keep `service-account.json` out of the repo as well.

---

## Local Development vs. CI/CD Credentials

When building a release locally, create `android/key.properties` pointing at your local keystore. CI generates it on the fly from the secrets above.

---

## Troubleshooting

### Keystore decoding / signing failures
Gradle can't find the keystore or the passwords don't match. Re-encode with `base64 -w 0` (no line breaks) and check `KEY_ALIAS` and both passwords.

### `Analyze` fails
Only errors fail the gate. Run `flutter analyze` locally and fix the reported errors.

### `Version code ... has already been used` / tag build fails on version check
The build number comes from pubspec. Bump `version:` (including the `+N`) before tagging, and make sure the tag name matches the version name.

### 16KB alignment failure
A 64-bit `.so` is 4KB aligned, or no 64-bit libraries were found. Update the offending plugin/package, or rebuild the native library with `-z max-page-size=16384`.

### Google Play upload authorization errors
Re-run just the `deploy` job once fixed. Verify the service account has release permissions in Play Console and the Google Play Android Developer API is enabled in its Google Cloud project.
