# CI/CD Pipeline: Google Play Store Release

This document describes the CI/CD pipeline configured for the **Arjun Guruji** Flutter application, which automates the build, validation, and deployment of release builds to the Google Play Store's Internal Testing track.

## Pipeline Overview
The CI/CD pipeline is implemented as a GitHub Actions workflow located at [.github/workflows/play-internal-testing.yml](file:///home/abhijith/coding/arjun_guruji/.github/workflows/play-internal-testing.yml).

- **Trigger:** Manual execution (`workflow_dispatch`) from the GitHub Actions tab.
- **Target Platform:** Android (Google Play Store)
- **Deployment Track:** Internal (Draft status)

---

## Workflow Steps Explained

Here is a breakdown of the steps performed by the runner (`ubuntu-latest`):

1. **Checkout & Environment Setup**
   - Checks out the repository code.
   - Sets up **Java 17** (Temurin distribution), required by modern Android Gradle builds.
   - Sets up **Flutter** (using the `stable` channel).
2. **Dependency & Cache Management**
   - Caches Flutter Pub dependencies (`~/.pub-cache`) to speed up subsequent runs.
   - Caches Gradle dependencies and wrappers (`~/.gradle/caches`, `~/.gradle/wrapper`).
3. **Keystore & Properties Generation**
   - Decodes the base64-encoded `KEYSTORE_FILE` secret and writes it to `android/app/release.keystore`.
   - Generates the `android/key.properties` configuration file on the fly with the keystore credentials retrieved from GitHub Secrets.
4. **Gradle Optimizations**
   - Appends performance-tuning parameters to `android/gradle.properties` (e.g., JVM memory allocation limits `-Xmx4g`, enables parallel execution, Jetifier, and Gradle caching).
5. **Flutter Build**
   - Retrieves project dependencies via `flutter pub get`.
   - Builds the Android App Bundle (`.aab`) in release mode with **obfuscation enabled** and splits debug symbols for crash reporting (`--split-debug-info`).
6. **Validation & Quality Checks**
   - **File Verification:** Verifies that the release AAB bundle was generated successfully at `build/app/outputs/bundle/release/app-release.aab`.
   - **16KB Page Size Alignment Scan:** Checks all `.so` (shared libraries) inside the AAB using `objdump`. This ensures compatibility with future Android devices requiring 16KB page size alignment.
7. **Google Play Upload**
   - Uploads the validated AAB to the Google Play Console under the `internal` testing track as a **draft** release using the service account credentials.

---

## Required GitHub Secrets

To run this pipeline successfully, the following secrets **must** be configured in the GitHub Repository settings (`Settings > Secrets and variables > Actions`):

| Secret Name | Description | Format/Example |
|-------------|-------------|----------------|
| `KEYSTORE_FILE` | Base64-encoded string of your release `.keystore`/`.jks` file. | Run `base64 -w 0 release.keystore` to generate. |
| `KEYSTORE_PASSWORD` | The password used to secure the keystore file. | Plaintext password string. |
| `KEY_ALIAS` | The alias assigned to the release key during generation. | e.g., `upload` or `arjunguruji-key`. |
| `KEY_PASSWORD` | The password for the specific key alias. | Plaintext password string. |
| `SERVICE_ACCOUNT_JSON` | Google Play Console Service Account key in JSON format. | Copy-paste the entire content of the service account `.json` file. |

### How to base64 encode the keystore file
Run the following command on your local terminal and copy the output:
```bash
base64 -w 0 android/app/release.keystore
```

---

## Local Development vs. CI/CD Credentials

During local development, you should avoid committing sensitive credential files like `key.properties` or `release.keystore`. 
- The project `.gitignore` includes patterns that prevent `.jks`, `.keystore`, and custom JSON credentials from being pushed to source control.
- When running locally, you must manually create a `key.properties` file under `android/` and point it to your local keystore path.

---

## Troubleshooting & Common Failures

### 1. Keystore Decoding Issues
* **Symptoms:** Gradle build fails claiming it cannot find the keystore file or passwords do not match.
* **Resolution:** Ensure the `KEYSTORE_FILE` secret was encoded with the correct base64 command (`-w 0` prevents introducing line breaks). Verify that the `KEY_ALIAS` and passwords match exactly.

### 2. 16KB Alignment Verification Failure
* **Symptoms:** The step `Verify 16KB Alignment for Native Libraries` fails, indicating a `.so` file is 4KB aligned.
* **Resolution:** Ensure all native dependencies and plugins used in the project support 16KB alignment. If a package distributes pre-compiled binaries aligned to 4KB, you may need to update the package or compile it yourself with the `-z max-page-size=16384` flag.

### 3. Google Play Service Account Authorization
* **Symptoms:** The upload step fails with API authorization errors.
* **Resolution:** Verify that the service account email is added to the Google Play Console with the necessary developer/release permissions, and the Google Play Android Developer API is enabled in your Google Cloud Project.
