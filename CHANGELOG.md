# Changelog

All notable changes to this project will be documented in this file.

## 2.2.0+17

### ✨ Features
- **Events & Panchang Revamp:** Replaced the default Event list entry page with a unified Calendar + daily Panchang + daily events view, prioritizing daily utility for users.
- **Amavasyant Calendar Support:** Integrated calculations using the Amavasyant (Amant) month system as the default.
- **Daily Tithi Segments & End Times:** Panchang Card now displays a precise timeline breakdown of all active tithi segments during the day, showing exact start and end times in Indian Standard Time (IST).
- **Glassmorphic Panchang UI:** Added a beautiful frosted glassmorphic card interface featuring an inline location search bar to easily filter the 30+ supported Indian cities without long scrolling.
- **Program Schedule Display:** Resolved a display gap in the Event Details screen, now showing the full timetable of scheduled sub-activities (e.g. morning Homa, evening Bhajans, etc.).
- **Global Background Audio:** Overhauled the `AudioPlayer` to use a global BLoC architecture with native `AndroidAudioFocus`. Audio now plays seamlessly in the background and ducks appropriately during phone calls and notifications.
- **Smart Exit Dialog:** Added intuitive back-button interception (via `PopScope`) on the player page, prompting users to "Keep Playing" or "Stop & Leave".
- **Now Playing Snackbar:** Implemented a persistent, global mini-player overlay across the entire application that allows instant play/pause controls and a quick return to the full player page.
- **Global Settings Management:** Introduced a comprehensive settings architecture to manage reading preferences (theme, font size, font style, and push notifications) globally across the app.
- **Offline Kannada Typography:** Bundled and integrated premium offline fonts (`Noto Sans Kannada` and `Noto Serif Kannada`), bypassing network dependencies for faster rendering.
- **Astottaras Local Caching:** Implemented a robust local caching layer for Astottaras using Hive, synchronized seamlessly with Firestore timestamps to ensure data consistency.
- **UPI & Donation Functionality:** Enhanced the Contact and Social Media pages with integrated donation options and UPI support.

### 🏗️ Architecture & Refactoring
- **16 KB Library Alignment:** Configured packaging options to align native binaries to 16 KB boundaries, ensuring compliance and seamless launches on Android 15/16 devices.
- **Settings Box Expansion:** Persisted the daily Panchang city setting (`panchangCity`) inside the existing Hive settings box, defaulting to Mysore.
- **City Alias Resolution:** Implemented alias resolution (e.g., Bengaluru -> Bangalore, Mysuru -> Mysore) to safely resolve common user input spelling variations against internal astronomical keys.
- **CI/CD Pipeline Optimization:** Hardened the GitHub Actions workflow for Play Store deployment, adding Dependency Caching, Gradle memory optimization (-Xmx4g), app obfuscation, and upgrading to the official Google Play upload action.
- **Android Target SDK Upgrade:** Upgraded the Android Target SDK to Version 36 to comply with the latest platform standards and optimizations.
- **Clean Architecture Migration:** Successfully decoupled the Presentation layer from the Data layer across major features (Notifications, Settings, Books, Audio).
- **Books Schema Upgrade:** Transitioned the Books feature to use dedicated local data sources and strong schema separation.
- **Error Handling Optimization:** Overhauled the application's global error handling and Freezed models logic to be more resilient and predictable.

### 🐛 Bug Fixes & UI Polish
- **Unified Reading Experience:** Centralized font size, style, and theme toggles in a beautiful new `SettingsPage`, cleaning up the UI in individual reading views (Books, Astottaras, Lyrics).
- **Dynamic Versioning:** The `SettingsPage` now dynamically displays the accurate app version utilizing `package_info_plus`.
- **Global Connectivity Overlays:** Fixed critical crashes related to the global internet connectivity listener and injected user-friendly non-intrusive snackbar alerts.
- **Downloads & Grids:** Improved the UI state management for downloading Books, balanced the Social Media links grid spacing, and refined Event list states.
